Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54F69117E2D
	for <lists+ceph-devel@lfdr.de>; Tue, 10 Dec 2019 04:30:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbfLJDat (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 9 Dec 2019 22:30:49 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:55702 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726619AbfLJDas (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 9 Dec 2019 22:30:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575948647;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MY8v9ynGNA79EFmjbVgzBZhCH3TDq95S3teahocXKng=;
        b=ZMHfTO0Zn94eun3h+dc35LyPBkMLZuJBIGzc7dFL85emz6maIPzgLprMA83oZ1PLDZM5v3
        31Z4SCGn5PGBJzzTsWvjKR+vsw6CS3CDArj8gm89Df6L0w1FLG/i9vcngSb8bV36ED2660
        hoNI3QN7SFvC4MQx7xv2pD1m62CZ2qQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-234-9dW3HgBiMBm5GWzXwNJwRQ-1; Mon, 09 Dec 2019 22:30:46 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4A65F2EED;
        Tue, 10 Dec 2019 03:30:45 +0000 (UTC)
Received: from [10.72.12.195] (ovpn-12-195.pek2.redhat.com [10.72.12.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 83F7D1001925;
        Tue, 10 Dec 2019 03:30:39 +0000 (UTC)
Subject: Re: [PATCH] ceph: clean the dirty page when session is closed or
 rejected
To:     Xiubo Li <xiubli@redhat.com>, Jeff Layton <jlayton@kernel.org>
Cc:     sage@redhat.com, idryomov@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
References: <20191209092830.22157-1-xiubli@redhat.com>
 <3db8af6d73324694035532611036d8bc5e3d9921.camel@kernel.org>
 <0d3d8008-f675-431d-0eb4-f064ea88aa5c@redhat.com>
From:   "Yan, Zheng" <zyan@redhat.com>
Message-ID: <65c38229-269d-a2ae-5de7-27fcd46b9582@redhat.com>
Date:   Tue, 10 Dec 2019 11:30:36 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <0d3d8008-f675-431d-0eb4-f064ea88aa5c@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: 9dW3HgBiMBm5GWzXwNJwRQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 12/9/19 7:54 PM, Xiubo Li wrote:
> On 2019/12/9 19:38, Jeff Layton wrote:
>> On Mon, 2019-12-09 at 04:28 -0500, xiubli@redhat.com wrote:
>>> From: Xiubo Li <xiubli@redhat.com>
>>>
>>> Try to queue writeback and invalidate the dirty pages when sessions
>>> are closed, rejected or reconnect denied.
>>>
>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>> ---
>>> =C2=A0 fs/ceph/mds_client.c | 13 +++++++++++++
>>> =C2=A0 1 file changed, 13 insertions(+)
>>>
>> Can you explain a bit more about the problem you're fixing? In what
>> situation is this currently broken, and what are the effects of that
>> breakage?
>>
>>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>>> index be1ac9f8e0e6..68f3b5ed6ac8 100644
>>> --- a/fs/ceph/mds_client.c
>>> +++ b/fs/ceph/mds_client.c
>>> @@ -1385,9 +1385,11 @@ static int remove_session_caps_cb(struct inode=
=20
>>> *inode, struct ceph_cap *cap,
>>> =C2=A0 {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct ceph_fs_client *fsc =3D (struct c=
eph_fs_client *)arg;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct ceph_inode_info *ci =3D ceph_inod=
e(inode);
>>> +=C2=A0=C2=A0=C2=A0 struct ceph_mds_session *session =3D cap->session;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 LIST_HEAD(to_remove);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bool dirty_dropped =3D false;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bool invalidate =3D false;
>>> +=C2=A0=C2=A0=C2=A0 bool writeback =3D false;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 dout("removing cap %p, ci is %p, inode i=
s %p\n",
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 cap, ci, &=
ci->vfs_inode);
>>> @@ -1398,12 +1400,21 @@ static int remove_session_caps_cb(struct=20
>>> inode *inode, struct ceph_cap *cap,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!ci->i_auth_cap) {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct ceph_cap_=
flush *cf;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct ceph_mds_=
client *mdsc =3D fsc->mdsc;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int s_state =3D session->s_=
state;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (READ_ONCE(fs=
c->mount_state) =3D=3D CEPH_MOUNT_SHUTDOWN) {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 if (inode->i_data.nrpages > 0)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 invalidate =3D true;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 if (ci->i_wrbuffer_ref > 0)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mapping_set_error(&inode->i_data, -EIO);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 } else if (s_state =3D=3D C=
EPH_MDS_SESSION_CLOSED ||
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 s_state =3D=3D CEPH_MDS_SESSION_REJECTED) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* =
reconnect denied or rejected */
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if =
(!__ceph_is_any_real_caps(ci) &&
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 inode->i_data.nrpages > 0)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 invalidate =3D true;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if =
(ci->i_wrbuffer_ref > 0)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 writeback =3D true;
>> I don't know here. If the session is CLOSED/REJECTED, is kicking off
>> writeback the right thing to do? In principle, this means that the
>> client may have been blacklisted and none of the writes will succeed.
>=20
> If the client was blacklisted,=C2=A0 it will be not safe to still buffer =
the=20
> data and flush it after the related sessions are reconnected without=20
> remounting.
>=20
> Maybe we need to throw it directly.

The auto reconnect code will invalidate page cache. I don't see why we=20
need to add this code.

>=20
>=20
>> Maybe this is the right thing to do, but I think I need more convincing.
>>
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 while (!list_emp=
ty(&ci->i_cap_flush_list)) {
>>> @@ -1472,6 +1483,8 @@ static int remove_session_caps_cb(struct inode=20
>>> *inode, struct ceph_cap *cap,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 wake_up_all(&ci->i_cap_wq);
>>> +=C2=A0=C2=A0=C2=A0 if (writeback)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ceph_queue_writeback(inode)=
;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (invalidate)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ceph_queue_inval=
idate(inode);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (dirty_dropped)
>> Thanks,
>=20
>=20

