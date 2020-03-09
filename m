Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E955D17E039
	for <lists+ceph-devel@lfdr.de>; Mon,  9 Mar 2020 13:27:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbgCIM1N (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 9 Mar 2020 08:27:13 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:49492 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726368AbgCIM1N (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 9 Mar 2020 08:27:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583756832;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2ACDlSNYK2ca11FMk6AFRN2lKUhJjPvmDvvmdrTwSrQ=;
        b=e6RjAYca5uRSiw3apFkF/aytPJ9Kv18gPOGUEGrq0oBN2p0p9Y6eWjk9E4UXMHd6qX4z2s
        R18YweZ8c11zwSzmZWGJaNUxmeJ4cBlMesadOgJxZGLMkSF842fzyj3KNAKGTUr5O5PHFV
        BVpQGDtwbBXAH9b2wJgk+JeOlvQy6m0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-295-ge4-8smtPUeDxRg-VMB4PA-1; Mon, 09 Mar 2020 08:27:09 -0400
X-MC-Unique: ge4-8smtPUeDxRg-VMB4PA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F120E107ACC4;
        Mon,  9 Mar 2020 12:27:07 +0000 (UTC)
Received: from [10.72.13.87] (ovpn-13-87.pek2.redhat.com [10.72.13.87])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4C9F55C1C3;
        Mon,  9 Mar 2020 12:27:03 +0000 (UTC)
Subject: Re: [PATCH v9 2/5] ceph: add caps perf metric for each session
To:     Jeff Layton <jlayton@kernel.org>, idryomov@gmail.com
Cc:     sage@redhat.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
References: <1583739430-4928-1-git-send-email-xiubli@redhat.com>
 <1583739430-4928-3-git-send-email-xiubli@redhat.com>
 <16b9a2a5bfbd8802ce2f2c435aba7331cd1adb35.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <a1954724-1de6-8880-b158-2b592f10701b@redhat.com>
Date:   Mon, 9 Mar 2020 20:26:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <16b9a2a5bfbd8802ce2f2c435aba7331cd1adb35.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/3/9 19:51, Jeff Layton wrote:
> On Mon, 2020-03-09 at 03:37 -0400, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> This will fulfill the cap hit/mis metric stuff per-superblock,
>> it will count the hit/mis counters based each inode, and if one
>> inode's 'issued & ~revoking =3D=3D mask' will mean a hit, or a miss.
>>
>> item          total           miss            hit
>> -------------------------------------------------
>> caps          295             107             4119
>>
>> URL: https://tracker.ceph.com/issues/43215
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/acl.c        |  2 +-
>>   fs/ceph/caps.c       | 19 +++++++++++++++++++
>>   fs/ceph/debugfs.c    | 16 ++++++++++++++++
>>   fs/ceph/dir.c        |  5 +++--
>>   fs/ceph/inode.c      |  4 ++--
>>   fs/ceph/mds_client.c | 26 ++++++++++++++++++++++----
>>   fs/ceph/metric.h     | 13 +++++++++++++
>>   fs/ceph/super.h      |  8 +++++---
>>   fs/ceph/xattr.c      |  4 ++--
>>   9 files changed, 83 insertions(+), 14 deletions(-)
>>
>> diff --git a/fs/ceph/acl.c b/fs/ceph/acl.c
>> index 26be652..e046574 100644
>> --- a/fs/ceph/acl.c
>> +++ b/fs/ceph/acl.c
>> @@ -22,7 +22,7 @@ static inline void ceph_set_cached_acl(struct inode =
*inode,
>>   	struct ceph_inode_info *ci =3D ceph_inode(inode);
>>  =20
>>   	spin_lock(&ci->i_ceph_lock);
>> -	if (__ceph_caps_issued_mask(ci, CEPH_CAP_XATTR_SHARED, 0))
>> +	if (__ceph_caps_issued_mask_metric(ci, CEPH_CAP_XATTR_SHARED, 0))
>>   		set_cached_acl(inode, type, acl);
>>   	else
>>   		forget_cached_acl(inode, type);
>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>> index 342a32c..efaeb67 100644
>> --- a/fs/ceph/caps.c
>> +++ b/fs/ceph/caps.c
>> @@ -912,6 +912,20 @@ int __ceph_caps_issued_mask(struct ceph_inode_inf=
o *ci, int mask, int touch)
>>   	return 0;
>>   }
>>  =20
>> +int __ceph_caps_issued_mask_metric(struct ceph_inode_info *ci, int ma=
sk,
>> +				   int touch)
>> +{
>> +	struct ceph_fs_client *fsc =3D ceph_sb_to_client(ci->vfs_inode.i_sb)=
;
>> +	int r;
>> +
>> +	r =3D __ceph_caps_issued_mask(ci, mask, touch);
>> +	if (r)
>> +		ceph_update_cap_hit(&fsc->mdsc->metric);
>> +	else
>> +		ceph_update_cap_mis(&fsc->mdsc->metric);
>> +	return r;
>> +}
>> +
>>   /*
>>    * Return true if mask caps are currently being revoked by an MDS.
>>    */
>> @@ -2680,6 +2694,11 @@ static int try_get_cap_refs(struct inode *inode=
, int need, int want,
>>   	if (snap_rwsem_locked)
>>   		up_read(&mdsc->snap_rwsem);
>>  =20
>> +	if (!ret)
>> +		ceph_update_cap_mis(&mdsc->metric);
> Should a negative error code here also mean a miss?

A negative error code could also from the case that if have & need =3D=3D=
=20
need, but it may fail with ret =3D -EAGAIN.

Or maybe could we just move this to :

if ((have & need) =3D=3D need){

 =C2=A0=C2=A0=C2=A0 hit()

} else {

 =C2=A0=C2=A0 miss()

}

Thanks

BRs


>> +	else if (ret =3D=3D 1)
>> +		ceph_update_cap_hit(&mdsc->metric);
>> +
>>   	dout("get_cap_refs %p ret %d got %s\n", inode,
>>   	     ret, ceph_cap_string(*got));
>>   	return ret;


