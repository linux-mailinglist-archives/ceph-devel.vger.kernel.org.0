Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19D3714E9E1
	for <lists+ceph-devel@lfdr.de>; Fri, 31 Jan 2020 10:02:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728225AbgAaJCj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 31 Jan 2020 04:02:39 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:25331 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728151AbgAaJCi (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 31 Jan 2020 04:02:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580461355;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ypaZ0HLhg6nP6FH2tRDi4UDH+1M/HeUgiOlZCLiOLY4=;
        b=KgSg+4ObVEAeOJngM/XBo8t3JElLeSrayRkxnuUSmNXZVryhmGr8n7Gr2pBQgtH4UL5St5
        a35XotZCJzN3X4dx1L+G78bcFPk6McvH+mcmFVrpBpKDu8WB1AMhklO3vrAjxIk7YCFUhx
        hKwY2jWdJPnUIUG8Qggr3OR5EwKs7R4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-182-XqGMCFdGM66lwWlxoVE2jQ-1; Fri, 31 Jan 2020 04:02:24 -0500
X-MC-Unique: XqGMCFdGM66lwWlxoVE2jQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7FC8A107ACCD;
        Fri, 31 Jan 2020 09:02:23 +0000 (UTC)
Received: from [10.72.12.34] (ovpn-12-34.pek2.redhat.com [10.72.12.34])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 55AF37792F;
        Fri, 31 Jan 2020 09:02:18 +0000 (UTC)
Subject: Re: [PATCH resend v5 02/11] ceph: add caps perf metric for each
 session
From:   Xiubo Li <xiubli@redhat.com>
To:     Jeffrey Layton <jlayton@kernel.org>, idryomov@gmail.com,
        zyan@redhat.com
Cc:     sage@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <20200129082715.5285-1-xiubli@redhat.com>
 <20200129082715.5285-3-xiubli@redhat.com>
 <a456a29671efa7a94a955bc8f1655bb042dbf13d.camel@kernel.org>
 <c60f2ad9-1b33-04d5-8b65-e4205880b345@redhat.com>
 <44f8f32e04b3fba2c6e444ba079cfd14ea180318.camel@kernel.org>
 <6d7f3509-80cc-4ff6-866a-09afde79309a@redhat.com>
Message-ID: <a6065c51-10fc-e4de-aae4-1401ef7ec998@redhat.com>
Date:   Fri, 31 Jan 2020 17:02:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <6d7f3509-80cc-4ff6-866a-09afde79309a@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/1/31 9:34, Xiubo Li wrote:
> On 2020/1/31 3:00, Jeffrey Layton wrote:
>> On Thu, 2020-01-30 at 10:22 +0800, Xiubo Li wrote:
>>> On 2020/1/29 22:21, Jeff Layton wrote:
>>>> On Wed, 2020-01-29 at 03:27 -0500, xiubli@redhat.com wrote:
>>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>>
>>>>> This will fulfill the caps hit/miss metric for each session. When
>>>>> checking the "need" mask and if one cap has the subset of the
>>>>> "need"
>>>>> mask it means hit, or missed.
>>>>>
>>>>> item=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 total=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 miss=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 hit
>>>>> -------------------------------------------------
>>>>> d_lease=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 295=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 993
>>>>>
>>>>> session=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 caps=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 miss=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 hit
>>>>> -------------------------------------------------
>>>>> 0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 295=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 107=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 4119
>>>>> 1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 107=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 9
>>>>>
>>>>> URL: https://tracker.ceph.com/issues/43215
>>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>>>> ---
>>>>> =C2=A0=C2=A0 fs/ceph/acl.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 |=C2=A0 2 ++
>>>>> =C2=A0=C2=A0 fs/ceph/addr.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=
=A0 2 ++
>>>>> =C2=A0=C2=A0 fs/ceph/caps.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 7=
4
>>>>> ++++++++++++++++++++++++++++++++++++++++++++
>>>>> =C2=A0=C2=A0 fs/ceph/debugfs.c=C2=A0=C2=A0=C2=A0 | 20 ++++++++++++
>>>>> =C2=A0=C2=A0 fs/ceph/dir.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 |=C2=A0 9 ++++--
>>>>> =C2=A0=C2=A0 fs/ceph/file.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=
=A0 3 ++
>>>>> =C2=A0=C2=A0 fs/ceph/mds_client.c | 16 +++++++++-
>>>>> =C2=A0=C2=A0 fs/ceph/mds_client.h |=C2=A0 3 ++
>>>>> =C2=A0=C2=A0 fs/ceph/quota.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 =
9 ++++--
>>>>> =C2=A0=C2=A0 fs/ceph/super.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 11 +++=
++++
>>>>> =C2=A0=C2=A0 fs/ceph/xattr.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 17 +++=
+++++--
>>>>> =C2=A0=C2=A0 11 files changed, 158 insertions(+), 8 deletions(-)
>>>>>
>>>>> diff --git a/fs/ceph/acl.c b/fs/ceph/acl.c
>>>>> index 26be6520d3fb..58e119e3519f 100644
>>>>> --- a/fs/ceph/acl.c
>>>>> +++ b/fs/ceph/acl.c
>>>>> @@ -22,6 +22,8 @@ static inline void ceph_set_cached_acl(struct
>>>>> inode *inode,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct ceph_inode_info *ci =3D=
 ceph_inode(inode);
>>>>> =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_lock(&ci->i_=
ceph_lock);
>>>>> +=C2=A0=C2=A0=C2=A0 __ceph_caps_metric(ci, CEPH_CAP_XATTR_SHARED);
>>>>> +
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (__ceph_caps_issued_mask(ci=
, CEPH_CAP_XATTR_SHARED,
>>>>> 0))
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 set_ca=
ched_acl(inode, type, acl);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 else
>>>>> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
>>>>> index 7ab616601141..29d4513eff8c 100644
>>>>> --- a/fs/ceph/addr.c
>>>>> +++ b/fs/ceph/addr.c
>>>>> @@ -1706,6 +1706,8 @@ int ceph_uninline_data(struct file *filp,
>>>>> struct page *locked_page)
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 err =3D -ENOMEM;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 goto out;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>>> +
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ceph_caps_metric(ci, CE=
PH_STAT_CAP_INLINE_DATA);
>>>> Should a check for inline data really count here?
>>> Currently all the INLINE_DATA is in 'force' mode, so we can ignore
>>> it.
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 err =3D=
 __ceph_do_getattr(inode, page,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 CEPH_STAT=
_CAP_INLINE_DA
>>>>> TA, true);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (er=
r < 0) {
>>>>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>>>>> index 7fc87b693ba4..af2e9e826f8c 100644
>>>>> --- a/fs/ceph/caps.c
>>>>> +++ b/fs/ceph/caps.c
>>>>> @@ -783,6 +783,75 @@ static int __cap_is_valid(struct ceph_cap
>>>>> *cap)
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 1;
>>>>> =C2=A0=C2=A0 }
>>>>> =C2=A0=C2=A0 +/*
>>>>> + * Counts the cap metric.
>>>>> + */
>>>> This needs some comments. Specifically, what should this be
>>>> counting and
>>>> how?
>>> Will add it.
>>>
>>> The __ceph_caps_metric() will traverse the inode's i_caps try to get
>>> the
>>> 'issued' excepting the 'invoking' caps until it get enough caps in
>>> 'mask'. The i_caps traverse logic is following
>>> __ceph_caps_issued_mask().
>>>
>>>
>>>>> +void __ceph_caps_metric(struct ceph_inode_info *ci, int mask)
>>>>> +{
>>>>> +=C2=A0=C2=A0=C2=A0 int have =3D ci->i_snap_caps;
>>>>> +=C2=A0=C2=A0=C2=A0 struct ceph_mds_session *s;
>>>>> +=C2=A0=C2=A0=C2=A0 struct ceph_cap *cap;
>>>>> +=C2=A0=C2=A0=C2=A0 struct rb_node *p;
>>>>> +=C2=A0=C2=A0=C2=A0 bool skip_auth =3D false;
>>>>> +
>>>>> +=C2=A0=C2=A0=C2=A0 lockdep_assert_held(&ci->i_ceph_lock);
>>>>> +
>>>>> +=C2=A0=C2=A0=C2=A0 if (mask <=3D 0)
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return;
>>>>> +
>>>>> +=C2=A0=C2=A0=C2=A0 /* Counts the snap caps metric in the auth cap =
*/
>>>>> +=C2=A0=C2=A0=C2=A0 if (ci->i_auth_cap) {
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 cap =3D ci->i_auth_cap;
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (have) {
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 have |=3D cap->issued;
>>>>> +
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 dout("%s %p cap %p issued %s, mask %s\n",
>>>>> __func__,
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &ci->vfs_inode, cap, ceph_cap_string(cap-
>>>>>> issued),
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ceph_cap_string(mask));
>>>>> +
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 s =3D ceph_get_mds_session(cap->session);
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 if (s) {
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 if (mask & have)
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 percpu_counter_inc(&s-
>>>>>> i_caps_hit);
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 else
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 percpu_counter_inc(&s-
>>>>>> i_caps_mis);
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 ceph_put_mds_session(s);
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 }
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 skip_auth =3D true;
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>>> +=C2=A0=C2=A0=C2=A0 }
>>>>> +
>>>>> +=C2=A0=C2=A0=C2=A0 if ((mask & have) =3D=3D mask)
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return;
>>>>> +
>>>>> +=C2=A0=C2=A0=C2=A0 /* Checks others */
>>>>> +=C2=A0=C2=A0=C2=A0 for (p =3D rb_first(&ci->i_caps); p; p =3D rb_n=
ext(p)) {
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 cap =3D rb_entry(p, str=
uct ceph_cap, ci_node);
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!__cap_is_valid(cap=
))
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 continue;
>>>>> +
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (skip_auth && cap =3D=
=3D ci->i_auth_cap)
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 continue;
>>>>> +
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 dout("%s %p cap %p issu=
ed %s, mask %s\n", __func__,
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 &ci->vfs_inode, cap, ceph_cap_string(cap->issued),
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 ceph_cap_string(mask));
>>>>> +
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 s =3D ceph_get_mds_sess=
ion(cap->session);
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (s) {
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 if (mask & cap->issued)
>>>>> + percpu_counter_inc(&s->i_caps_hit);
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 else
>>>>> + percpu_counter_inc(&s->i_caps_mis);
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 ceph_put_mds_session(s);
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>>> +
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 have |=3D cap->issued;
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if ((mask & have) =3D=3D=
 mask)
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 return;
>>>>> +=C2=A0=C2=A0=C2=A0 }
>>>>> +}
>>>>> +
>>>> I'm trying to understand what happens with the above when more than
>>>> one
>>>> ceph_cap has the same bit set in "issued". For instance:
>>>>
>>>> Suppose we're doing the check for a statx call, and we're trying to
>>>> get
>>>> caps for pAsFsLs. We have two MDS's and they've each granted us
>>>> caps for
>>>> the inode, say:
>>>>
>>>> MDS 0: pAs
>>>> MDS 1: pAsLsFs
>>>>
>>>> We check the cap0 first, and consider it a hit, and then we check
>>>> cap1
>>>> and consider it a hit as well. So that seems like it's being
>>>> double-
>>>> counted.
>>> Yeah, it will.
>>>
>>> In case2:
>>>
>>> MDS 0: pAsFs
>>>
>>> MDS 1: pAsLs
>>>
>>> For this case and yours both the i_cap0 and i_cap1 are 'hit'.
>>>
>>>
>>> In case3 :
>>>
>>> MDS0: pAsFsLs
>>>
>>> MDS1: pAs
>>>
>>> Only the i_cap0 is 'hit'.=C2=A0 i_cap1 will not be counted any 'hit' =
or
>>> 'mis'.
>>>
>>>
>>> In case4:
>>>
>>> MDS0: p
>>>
>>> MDS1: pAsLsFs
>>>
>>> i_cap0 will 'mis' and i_cap1 will 'hit'.
>>>
>>>
>>> All the logic are the same with __ceph_caps_issued_mask() does.
>>>
>>> The 'hit' means to get all the caps in 'mask we have checked the
>>> i_cap[0~N] and if they have a subset in 'mask', and the 'mis' means
>>> we
>>> have checked the i_cap[0~N] but they do not.
>>>
>>> For the i_cap[N+1 ~ M], if we won't touch them because we have
>>> already
>>> gotten enough caps needed in 'mask', they won't count any 'hit' or
>>> 'mis'
>>>
>>> All in all, the current logic is that the 'hit' means 'touched' and
>>> it
>>> have some of what we needed, and the 'mis' means 'touched' and
>>> missed
>>> any of what we needed.
>>>
>>>
>> That seems sort of arbitrary, given that you're going to get different
>> results depending on the index of the MDS with the caps. For instance:
>>
>>
>> MDS0: pAsLsFs
>> MDS1: pAs
>>
>> ...vs...
>>
>> MDS0: pAs
>> MDS1: pAsLsFs
>>
>> If we assume we're looking for pAsLsFs, then the first scenario will
>> just end up with 1 hit and the second will give you 2. AFAIU, the two
>> MDSs are peers, so it really seems like the index should not matter
>> here.
>>
>> I'm really struggling to understand how these numbers will be useful.
>> What, specifically, are we trying to count here and why?
>
> Maybe we need count the hit/mis only once, the fake code like:
>
> // Case1: check the auth caps first
>
> if (auth_cap & mask =3D=3D mask) {
>
> =C2=A0=C2=A0=C2=A0 s->hit++;
>
> =C2=A0=C2=A0=C2=A0 return;
>
> }
>
> // Case2: check all the other one by one
>
> for (caps : i_caps) {
>
> =C2=A0=C2=A0=C2=A0 if (caps & mask =3D=3D mask) {
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 s->hit++;
>
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return;
>
> =C2=A0=C2=A0=C2=A0 }
>
> =C2=A0=C2=A0=C2=A0 c |=3D caps;
>
> }
>
> // Case3:
>
> if (c & mask =3D=3D mask)
>
> =C2=A0=C2=A0=C2=A0 s->hit++;
>
> else
>
> =C2=A0=C2=A0=C2=A0 s->mis++;
>
> return;
>
> ....
>
> And for the session 's->' here, if one i_cap can hold all the 'mask'=20
> requested, like the Case1 and Case2 it will be i_cap's corresponding=20
> session. Or for Case3 we could choose any session.
>
> But the above is still not very graceful of counting the cap metrics to=
o.
>
> IMO, for the cap hit/miss counter should be a global one just like the=20
> dentry_lease does in [PATCH 01/11], will this make sense ?
>
Currently in fuse client, for each inode it is its auth_cap->session's=20
responsibility to do all the cap hit/mis counting if it has a auth_cap,=20
or choose any one exist.

Maybe this is one acceptable approach.

> Thanks,
>
>
>>>> ISTM, that what you really want to do here is logically or all of
>>>> the
>>>> cap->issued fields together, and then check that vs. the mask
>>>> value, and
>>>> count only one hit or miss per inode.
>>>>
>>>> That said, it's not 100% clear what you're counting as a hit or
>>>> miss
>>>> here, so please let me know if I have that wrong.
>>>>> =C2=A0=C2=A0 /*
>>>>> =C2=A0=C2=A0=C2=A0 * Return set of valid cap bits issued to us.=C2=A0=
 Note that caps
>>>>> time
>>>>> =C2=A0=C2=A0=C2=A0 * out, and may be invalidated in bulk if the cli=
ent session
>>>>> times out
>>>>> @@ -2746,6 +2815,7 @@ static void check_max_size(struct inode
>>>>> *inode, loff_t endoff)
>>>>> =C2=A0=C2=A0 int ceph_try_get_caps(struct inode *inode, int need, i=
nt want,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 bool nonblock, int *got)
>>>>> =C2=A0=C2=A0 {
>>>>> +=C2=A0=C2=A0=C2=A0 struct ceph_inode_info *ci =3D ceph_inode(inode=
);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int ret;
>>>>> =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BUG_ON(need & ~CE=
PH_CAP_FILE_RD);
>>>>> @@ -2758,6 +2828,7 @@ int ceph_try_get_caps(struct inode *inode,
>>>>> int need, int want,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BUG_ON(want & ~(CEPH_CAP_FILE_=
CACHE |
>>>>> CEPH_CAP_FILE_LAZYIO |
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 CEPH_CAP_FILE_SHARED |
>>>>> CEPH_CAP_FILE_EXCL |
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 CEPH_CAP_ANY_DIR_OPS));
>>>>> +=C2=A0=C2=A0=C2=A0 ceph_caps_metric(ci, need | want);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D try_get_cap_refs(inode=
, need, want, 0, nonblock,
>>>>> got);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return ret =3D=3D -EAGAIN ? 0 =
: ret;
>>>>> =C2=A0=C2=A0 }
>>>>> @@ -2784,6 +2855,8 @@ int ceph_get_caps(struct file *filp, int
>>>>> need, int want,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fi->fi=
lp_gen !=3D READ_ONCE(fsc->filp_gen))
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return=
 -EBADF;
>>>>> =C2=A0=C2=A0 +=C2=A0=C2=A0=C2=A0 ceph_caps_metric(ci, need | want);
>>>>> +
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 while (true) {
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (en=
doff > 0)
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 check_max_size(inode, endoff);
>>>>> @@ -2871,6 +2944,7 @@ int ceph_get_caps(struct file *filp, int
>>>>> need, int want,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 * getattr request will bring inline
>>>>> data into
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 * page cache
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 */
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 ceph_caps_metric(ci,
>>>>> CEPH_STAT_CAP_INLINE_DATA);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 ret =3D __ceph_do_getattr(inode, NULL,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 CEPH_STAT_CAP_I
>>>>> NLINE_DATA,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 true);
>>>>> diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
>>>>> index 40a22da0214a..c132fdb40d53 100644
>>>>> --- a/fs/ceph/debugfs.c
>>>>> +++ b/fs/ceph/debugfs.c
>>>>> @@ -128,6 +128,7 @@ static int metric_show(struct seq_file *s,
>>>>> void *p)
>>>>> =C2=A0=C2=A0 {
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct ceph_fs_client *fsc =3D=
 s->private;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct ceph_mds_client *mdsc =3D=
 fsc->mdsc;
>>>>> +=C2=A0=C2=A0=C2=A0 int i;
>>>>> =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 seq_printf(s,
>>>>> "item=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 total=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 miss=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 hit\n");
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 seq_printf(s, "---------------=
-----------------------
>>>>> -----------\n");
>>>>> @@ -137,6 +138,25 @@ static int metric_show(struct seq_file *s,
>>>>> void *p)
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 percpu_counter_sum(&mdsc-
>>>>>> metric.d_lease_mis),
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 percpu_counter_sum(&mdsc-
>>>>>> metric.d_lease_hit));
>>>>> =C2=A0=C2=A0 +=C2=A0=C2=A0=C2=A0 seq_printf(s, "\n");
>>>>> +=C2=A0=C2=A0=C2=A0 seq_printf(s,
>>>>> "session=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 caps=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 miss=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 hit\n");
>>>>> +=C2=A0=C2=A0=C2=A0 seq_printf(s, "--------------------------------=
--------------
>>>>> ---\n");
>>>>> +
>>>>> +=C2=A0=C2=A0=C2=A0 mutex_lock(&mdsc->mutex);
>>>>> +=C2=A0=C2=A0=C2=A0 for (i =3D 0; i < mdsc->max_sessions; i++) {
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct ceph_mds_session=
 *session;
>>>>> +
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 session =3D __ceph_look=
up_mds_session(mdsc, i);
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!session)
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 continue;
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 seq_printf(s, "%-14d%-1=
6d%-16lld%lld\n", i,
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 session->s_nr_caps,
>>>>> + percpu_counter_sum(&session->i_caps_mis),
>>>>> + percpu_counter_sum(&session->i_caps_hit));
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ceph_put_mds_session(se=
ssion);
>>>>> +=C2=A0=C2=A0=C2=A0 }
>>>>> +=C2=A0=C2=A0=C2=A0 mutex_unlock(&mdsc->mutex);
>>>>> +
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 0;
>>>>> =C2=A0=C2=A0 }
>>>>> =C2=A0=C2=A0 diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
>>>>> index 658c55b323cc..33eb239e09e2 100644
>>>>> --- a/fs/ceph/dir.c
>>>>> +++ b/fs/ceph/dir.c
>>>>> @@ -313,7 +313,7 @@ static int ceph_readdir(struct file *file,
>>>>> struct dir_context *ctx)
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct ceph_fs_client *fsc =3D
>>>>> ceph_inode_to_client(inode);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct ceph_mds_client *mdsc =3D=
 fsc->mdsc;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int i;
>>>>> -=C2=A0=C2=A0=C2=A0 int err;
>>>>> +=C2=A0=C2=A0=C2=A0 int err, ret =3D -1;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned frag =3D -1;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct ceph_mds_reply_info_par=
sed *rinfo;
>>>>> =C2=A0=C2=A0 @@ -346,13 +346,16 @@ static int ceph_readdir(struct f=
ile *file,
>>>>> struct dir_context *ctx)
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 !ceph_=
test_mount_opt(fsc, NOASYNCREADDIR) &&
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ceph_s=
nap(inode) !=3D CEPH_SNAPDIR &&
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __ceph=
_dir_is_complete_ordered(ci) &&
>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __ceph_caps_issued_mask=
(ci, CEPH_CAP_FILE_SHARED, 1)) {
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (ret =3D __ceph_caps_is=
sued_mask(ci, CEPH_CAP_FILE_SHARED,
>>>>> 1))) {
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int sh=
ared_gen =3D atomic_read(&ci-
>>>>>> i_shared_gen);
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __ceph_caps_metric(ci, =
CEPH_CAP_XATTR_SHARED);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_u=
nlock(&ci->i_ceph_lock);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 err =3D=
 __dcache_readdir(file, ctx, shared_gen);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (er=
r !=3D -EAGAIN)
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 return err;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 } else {
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret !=3D -1)
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 __ceph_caps_metric(ci, CEPH_CAP_XATTR_SHARED);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_u=
nlock(&ci->i_ceph_lock);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>>> =C2=A0=C2=A0 @@ -757,6 +760,8 @@ static struct dentry *ceph_lookup(=
struct
>>>>> inode *dir, struct dentry *dentry,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct=
 ceph_dentry_info *di =3D
>>>>> ceph_dentry(dentry);
>>>>> =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 spin_lock(&ci->i_ceph_lock);
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __ceph_caps_metric(ci, =
CEPH_CAP_FILE_SHARED);
>>>>> +
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 dout("=
 dir %p flags are %d\n", dir, ci-
>>>>>> i_ceph_flags);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (st=
rncmp(dentry->d_name.name,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fsc->mount_options->snapdir_name,
>>>>> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
>>>>> index 1e6cdf2dfe90..c78dfbbb7b91 100644
>>>>> --- a/fs/ceph/file.c
>>>>> +++ b/fs/ceph/file.c
>>>>> @@ -384,6 +384,8 @@ int ceph_open(struct inode *inode, struct
>>>>> file *file)
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * asynchronously.
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_lock(&ci->i_ceph_lock);
>>>>> +=C2=A0=C2=A0=C2=A0 __ceph_caps_metric(ci, wanted);
>>>>> +
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (__ceph_is_any_real_caps(ci=
) &&
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (((fmo=
de & CEPH_FILE_MODE_WR) =3D=3D 0) || ci-
>>>>>> i_auth_cap)) {
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int md=
s_wanted =3D __ceph_caps_mds_wanted(ci,
>>>>> true);
>>>>> @@ -1340,6 +1342,7 @@ static ssize_t ceph_read_iter(struct kiocb
>>>>> *iocb, struct iov_iter *to)
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -ENOMEM;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>>> =C2=A0=C2=A0 +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ceph_caps_=
metric(ci, CEPH_STAT_CAP_INLINE_DATA);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 statre=
t =3D __ceph_do_getattr(inode, page,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 CEPH_STAT_CAP_INLIN
>>>>> E_DATA, !!page);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (st=
atret < 0) {
>>>>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>>>>> index a24fd00676b8..141c1c03636c 100644
>>>>> --- a/fs/ceph/mds_client.c
>>>>> +++ b/fs/ceph/mds_client.c
>>>>> @@ -558,6 +558,8 @@ void ceph_put_mds_session(struct
>>>>> ceph_mds_session *s)
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (refcount_dec_and_test(&s->=
s_ref)) {
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (s-=
>s_auth.authorizer)
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 ceph_auth_destroy_authorizer(s-
>>>>>> s_auth.authorizer);
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 percpu_counter_destroy(=
&s->i_caps_hit);
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 percpu_counter_destroy(=
&s->i_caps_mis);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kfree(=
s);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>>> =C2=A0=C2=A0 }
>>>>> @@ -598,6 +600,7 @@ static struct ceph_mds_session
>>>>> *register_session(struct ceph_mds_client *mdsc,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 int mds)
>>>>> =C2=A0=C2=A0 {
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct ceph_mds_session *s;
>>>>> +=C2=A0=C2=A0=C2=A0 int err;
>>>>> =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (mds >=3D mdsc=
->mdsmap->possible_max_rank)
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return=
 ERR_PTR(-EINVAL);
>>>>> @@ -612,8 +615,10 @@ static struct ceph_mds_session
>>>>> *register_session(struct ceph_mds_client *mdsc,
>>>>> =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 dout("%s: realloc to %d\n", __func__, newmax);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sa =3D=
 kcalloc(newmax, sizeof(void *), GFP_NOFS);
>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!sa)
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!sa) {
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 err =3D -ENOMEM;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 goto fail_realloc;
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (md=
sc->sessions) {
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 memcpy(sa, mdsc->sessions,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mdsc->max_sessi=
ons * sizeof(void
>>>>> *));
>>>>> @@ -653,6 +658,13 @@ static struct ceph_mds_session
>>>>> *register_session(struct ceph_mds_client *mdsc,
>>>>> =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 INIT_LIST_HEAD(&s=
->s_cap_flushing);
>>>>> =C2=A0=C2=A0 +=C2=A0=C2=A0=C2=A0 err =3D percpu_counter_init(&s->i_=
caps_hit, 0, GFP_NOFS);
>>>>> +=C2=A0=C2=A0=C2=A0 if (err)
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto fail_realloc;
>>>>> +=C2=A0=C2=A0=C2=A0 err =3D percpu_counter_init(&s->i_caps_mis, 0, =
GFP_NOFS);
>>>>> +=C2=A0=C2=A0=C2=A0 if (err)
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto fail_init;
>>>>> +
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mdsc->sessions[mds] =3D s;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 atomic_inc(&mdsc->num_sessions=
);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 refcount_inc(&s->s_ref);=C2=A0=
 /* one ref to sessions[], one
>>>>> to caller */
>>>>> @@ -662,6 +674,8 @@ static struct ceph_mds_session
>>>>> *register_session(struct ceph_mds_client *mdsc,
>>>>> =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return s;
>>>>> =C2=A0=C2=A0 +fail_init:
>>>>> +=C2=A0=C2=A0=C2=A0 percpu_counter_destroy(&s->i_caps_hit);
>>>>> =C2=A0=C2=A0 fail_realloc:
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kfree(s);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return ERR_PTR(-ENOMEM);
>>>>> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
>>>>> index dd1f417b90eb..ba74ff74c59c 100644
>>>>> --- a/fs/ceph/mds_client.h
>>>>> +++ b/fs/ceph/mds_client.h
>>>>> @@ -201,6 +201,9 @@ struct ceph_mds_session {
>>>>> =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct list_head=C2=
=A0 s_waiting;=C2=A0 /* waiting requests */
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct list_head=C2=A0 s_unsaf=
e;=C2=A0=C2=A0 /* unsafe requests */
>>>>> +
>>>>> +=C2=A0=C2=A0=C2=A0 struct percpu_counter i_caps_hit;
>>>>> +=C2=A0=C2=A0=C2=A0 struct percpu_counter i_caps_mis;
>>>>> =C2=A0=C2=A0 };
>>>>> =C2=A0=C2=A0 =C2=A0=C2=A0 /*
>>>>> diff --git a/fs/ceph/quota.c b/fs/ceph/quota.c
>>>>> index de56dee60540..4ce2f658e63d 100644
>>>>> --- a/fs/ceph/quota.c
>>>>> +++ b/fs/ceph/quota.c
>>>>> @@ -147,9 +147,14 @@ static struct inode
>>>>> *lookup_quotarealm_inode(struct ceph_mds_client *mdsc,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return=
 NULL;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (qri->inode) {
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct ceph_inode_info =
*ci =3D ceph_inode(qri->inode);
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int ret;
>>>>> +
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ceph_caps_metric(ci, CE=
PH_STAT_CAP_INODE);
>>>>> +
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* get=
 caps */
>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int ret =3D __ceph_do_g=
etattr(qri->inode, NULL,
>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
CEPH_STAT_CAP_INODE, true);
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D __ceph_do_getat=
tr(qri->inode, NULL,
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 CEPH_STAT_CAP_INODE, tru=
e);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (re=
t >=3D 0)
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 in =3D qri->inode;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 else
>>>>> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
>>>>> index 7af91628636c..3f4829222528 100644
>>>>> --- a/fs/ceph/super.h
>>>>> +++ b/fs/ceph/super.h
>>>>> @@ -641,6 +641,14 @@ static inline bool
>>>>> __ceph_is_any_real_caps(struct ceph_inode_info *ci)
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return !RB_EMPTY_ROOT(&ci->i_c=
aps);
>>>>> =C2=A0=C2=A0 }
>>>>> =C2=A0=C2=A0 +extern void __ceph_caps_metric(struct ceph_inode_info=
 *ci, int
>>>>> mask);
>>>>> +static inline void ceph_caps_metric(struct ceph_inode_info *ci,
>>>>> int mask)
>>>>> +{
>>>>> +=C2=A0=C2=A0=C2=A0 spin_lock(&ci->i_ceph_lock);
>>>>> +=C2=A0=C2=A0=C2=A0 __ceph_caps_metric(ci, mask);
>>>>> +=C2=A0=C2=A0=C2=A0 spin_unlock(&ci->i_ceph_lock);
>>>>> +}
>>>>> +
>>>>> =C2=A0=C2=A0 extern int __ceph_caps_issued(struct ceph_inode_info *=
ci, int
>>>>> *implemented);
>>>>> =C2=A0=C2=A0 extern int __ceph_caps_issued_mask(struct ceph_inode_i=
nfo *ci,
>>>>> int mask, int t);
>>>>> =C2=A0=C2=A0 extern int __ceph_caps_issued_other(struct ceph_inode_=
info *ci,
>>>>> @@ -927,6 +935,9 @@ extern int __ceph_do_getattr(struct inode
>>>>> *inode, struct page *locked_page,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int mask, bool force);
>>>>> =C2=A0=C2=A0 static inline int ceph_do_getattr(struct inode *inode,=
 int
>>>>> mask, bool force)
>>>>> =C2=A0=C2=A0 {
>>>>> +=C2=A0=C2=A0=C2=A0 struct ceph_inode_info *ci =3D ceph_inode(inode=
);
>>>>> +
>>>>> +=C2=A0=C2=A0=C2=A0 ceph_caps_metric(ci, mask);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return __ceph_do_getattr(inode=
, NULL, mask, force);
>>>>> =C2=A0=C2=A0 }
>>>>> =C2=A0=C2=A0 extern int ceph_permission(struct inode *inode, int ma=
sk);
>>>>> diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
>>>>> index d58fa14c1f01..ebd522edb0a8 100644
>>>>> --- a/fs/ceph/xattr.c
>>>>> +++ b/fs/ceph/xattr.c
>>>>> @@ -829,6 +829,7 @@ ssize_t __ceph_getxattr(struct inode *inode,
>>>>> const char *name, void *value,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct ceph_vxattr *vxattr =3D=
 NULL;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int req_mask;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ssize_t err;
>>>>> +=C2=A0=C2=A0=C2=A0 int ret =3D -1;
>>>>> =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* let's see if a=
 virtual xattr was requested */
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 vxattr =3D ceph_match_vxattr(i=
node, name);
>>>>> @@ -856,7 +857,9 @@ ssize_t __ceph_getxattr(struct inode *inode,
>>>>> const char *name, void *value,
>>>>> =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ci->i_xattrs.=
version =3D=3D 0 ||
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 !((req=
_mask & CEPH_CAP_XATTR_SHARED) ||
>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __ceph_caps=
_issued_mask(ci, CEPH_CAP_XATTR_SHARED, 1))) {
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (ret =3D __=
ceph_caps_issued_mask(ci, CEPH_CAP_XATTR_SHARED,
>>>>> 1)))) {
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret !=3D -1)
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 __ceph_caps_metric(ci, CEPH_CAP_XATTR_SHARED);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_u=
nlock(&ci->i_ceph_lock);
>>>>> =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 /* security module gets xattr while filling
>>>>> trace */
>>>>> @@ -871,6 +874,9 @@ ssize_t __ceph_getxattr(struct inode *inode,
>>>>> const char *name, void *value,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (er=
r)
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 return err;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_l=
ock(&ci->i_ceph_lock);
>>>>> +=C2=A0=C2=A0=C2=A0 } else {
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret !=3D -1)
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 __ceph_caps_metric(ci, CEPH_CAP_XATTR_SHARED);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>>> =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 err =3D __build_x=
attrs(inode);
>>>>> @@ -907,19 +913,24 @@ ssize_t ceph_listxattr(struct dentry
>>>>> *dentry, char *names, size_t size)
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct ceph_inode_info *ci =3D=
 ceph_inode(inode);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bool len_only =3D (size =3D=3D=
 0);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u32 namelen;
>>>>> -=C2=A0=C2=A0=C2=A0 int err;
>>>>> +=C2=A0=C2=A0=C2=A0 int err, ret =3D -1;
>>>>> =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_lock(&ci->i_=
ceph_lock);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 dout("listxattr %p ver=3D%lld =
index_ver=3D%lld\n", inode,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
ci->i_xattrs.version, ci->i_xattrs.index_version);
>>>>> =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ci->i_xattrs.=
version =3D=3D 0 ||
>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 !__ceph_caps_issued_mas=
k(ci, CEPH_CAP_XATTR_SHARED, 1)) {
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 !(ret =3D __ceph_caps_i=
ssued_mask(ci, CEPH_CAP_XATTR_SHARED,
>>>>> 1))) {
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret !=3D -1)
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 __ceph_caps_metric(ci, CEPH_CAP_XATTR_SHARED);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_u=
nlock(&ci->i_ceph_lock);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 err =3D=
 ceph_do_getattr(inode,
>>>>> CEPH_STAT_CAP_XATTR, true);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (er=
r)
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 return err;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_l=
ock(&ci->i_ceph_lock);
>>>>> +=C2=A0=C2=A0=C2=A0 } else {
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret !=3D -1)
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 __ceph_caps_metric(ci, CEPH_CAP_XATTR_SHARED);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>>> =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 err =3D __build_x=
attrs(inode);
>>>
>

