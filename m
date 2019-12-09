Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A65FE116C96
	for <lists+ceph-devel@lfdr.de>; Mon,  9 Dec 2019 12:55:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727576AbfLILzN (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 9 Dec 2019 06:55:13 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:46472 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727163AbfLILzN (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 9 Dec 2019 06:55:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575892512;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DtIdEHesoSIb9e0xjWji8oIrRtxF3VvnAWlRRqMc840=;
        b=KWkt5pCJ5Vtqw//KgqQG34yKG8bsT43Mvhta7a3AUQ7uIMbV1B7FmsSw8l5fm8Mzj3jNcG
        dK8YLXGZ9MzS37MUQey8fWZHoW+Z84hLP8tHrKN7YhhPS95r5aktt7rJAh9Tv7dfa/7Kqx
        aa4OWBbStakffuGnF/YXlT81ea++j9E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-134-RIGfvy9LP3Gbg41W3JqLTw-1; Mon, 09 Dec 2019 06:55:08 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D9153801E53;
        Mon,  9 Dec 2019 11:55:07 +0000 (UTC)
Received: from [10.72.12.181] (ovpn-12-181.pek2.redhat.com [10.72.12.181])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0E6445D9D6;
        Mon,  9 Dec 2019 11:55:00 +0000 (UTC)
Subject: Re: [PATCH] ceph: clean the dirty page when session is closed or
 rejected
To:     Jeff Layton <jlayton@kernel.org>
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <20191209092830.22157-1-xiubli@redhat.com>
 <3db8af6d73324694035532611036d8bc5e3d9921.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <0d3d8008-f675-431d-0eb4-f064ea88aa5c@redhat.com>
Date:   Mon, 9 Dec 2019 19:54:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <3db8af6d73324694035532611036d8bc5e3d9921.camel@kernel.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: RIGfvy9LP3Gbg41W3JqLTw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2019/12/9 19:38, Jeff Layton wrote:
> On Mon, 2019-12-09 at 04:28 -0500, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> Try to queue writeback and invalidate the dirty pages when sessions
>> are closed, rejected or reconnect denied.
>>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/mds_client.c | 13 +++++++++++++
>>   1 file changed, 13 insertions(+)
>>
> Can you explain a bit more about the problem you're fixing? In what
> situation is this currently broken, and what are the effects of that
> breakage?
>
>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>> index be1ac9f8e0e6..68f3b5ed6ac8 100644
>> --- a/fs/ceph/mds_client.c
>> +++ b/fs/ceph/mds_client.c
>> @@ -1385,9 +1385,11 @@ static int remove_session_caps_cb(struct inode *i=
node, struct ceph_cap *cap,
>>   {
>>   =09struct ceph_fs_client *fsc =3D (struct ceph_fs_client *)arg;
>>   =09struct ceph_inode_info *ci =3D ceph_inode(inode);
>> +=09struct ceph_mds_session *session =3D cap->session;
>>   =09LIST_HEAD(to_remove);
>>   =09bool dirty_dropped =3D false;
>>   =09bool invalidate =3D false;
>> +=09bool writeback =3D false;
>>  =20
>>   =09dout("removing cap %p, ci is %p, inode is %p\n",
>>   =09     cap, ci, &ci->vfs_inode);
>> @@ -1398,12 +1400,21 @@ static int remove_session_caps_cb(struct inode *=
inode, struct ceph_cap *cap,
>>   =09if (!ci->i_auth_cap) {
>>   =09=09struct ceph_cap_flush *cf;
>>   =09=09struct ceph_mds_client *mdsc =3D fsc->mdsc;
>> +=09=09int s_state =3D session->s_state;
>>  =20
>>   =09=09if (READ_ONCE(fsc->mount_state) =3D=3D CEPH_MOUNT_SHUTDOWN) {
>>   =09=09=09if (inode->i_data.nrpages > 0)
>>   =09=09=09=09invalidate =3D true;
>>   =09=09=09if (ci->i_wrbuffer_ref > 0)
>>   =09=09=09=09mapping_set_error(&inode->i_data, -EIO);
>> +=09=09} else if (s_state =3D=3D CEPH_MDS_SESSION_CLOSED ||
>> +=09=09=09   s_state =3D=3D CEPH_MDS_SESSION_REJECTED) {
>> +=09=09=09/* reconnect denied or rejected */
>> +=09=09=09if (!__ceph_is_any_real_caps(ci) &&
>> +=09=09=09    inode->i_data.nrpages > 0)
>> +=09=09=09=09invalidate =3D true;
>> +=09=09=09if (ci->i_wrbuffer_ref > 0)
>> +=09=09=09=09writeback =3D true;
> I don't know here. If the session is CLOSED/REJECTED, is kicking off
> writeback the right thing to do? In principle, this means that the
> client may have been blacklisted and none of the writes will succeed.

If the client was blacklisted,=C2=A0 it will be not safe to still buffer th=
e=20
data and flush it after the related sessions are reconnected without=20
remounting.

Maybe we need to throw it directly.


> Maybe this is the right thing to do, but I think I need more convincing.
>
>>   =09=09}
>>  =20
>>   =09=09while (!list_empty(&ci->i_cap_flush_list)) {
>> @@ -1472,6 +1483,8 @@ static int remove_session_caps_cb(struct inode *in=
ode, struct ceph_cap *cap,
>>   =09}
>>  =20
>>   =09wake_up_all(&ci->i_cap_wq);
>> +=09if (writeback)
>> +=09=09ceph_queue_writeback(inode);
>>   =09if (invalidate)
>>   =09=09ceph_queue_invalidate(inode);
>>   =09if (dirty_dropped)
> Thanks,


