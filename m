Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD0C913D1C4
	for <lists+ceph-devel@lfdr.de>; Thu, 16 Jan 2020 02:57:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730412AbgAPB5b (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 15 Jan 2020 20:57:31 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:47674 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729615AbgAPB5b (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 15 Jan 2020 20:57:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579139849;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tpX2DaykjJ7jeV1R/V5/HQAqTyiB5+JZZ0CVyKs80kY=;
        b=bDJfbaWUvvjOTguDvBSbMvS4HBV4fxYxMLlV4+Qkldl0dOI/O+1Ut1Hd1LUq8DvT0PYT0f
        /qoPyE0KfPJvhQacGiQAadZ8hnE3/3GbPyWWWtMjrupjVi1OxL903mCxl3q0lxxRYgJg9L
        UP/0kSeGpsoPIUrnFu9SEkcyklf2i9w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-374-cbMUlCFoMs-2fEvwbd_3pA-1; Wed, 15 Jan 2020 20:57:28 -0500
X-MC-Unique: cbMUlCFoMs-2fEvwbd_3pA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 59416800D41;
        Thu, 16 Jan 2020 01:57:27 +0000 (UTC)
Received: from [10.72.12.49] (ovpn-12-49.pek2.redhat.com [10.72.12.49])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D3E39811E7;
        Thu, 16 Jan 2020 01:57:22 +0000 (UTC)
Subject: Re: [PATCH v3 2/8] ceph: add caps perf metric for each session
To:     Jeff Layton <jlayton@kernel.org>, idryomov@gmail.com,
        zyan@redhat.com
Cc:     sage@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <20200115034444.14304-1-xiubli@redhat.com>
 <20200115034444.14304-3-xiubli@redhat.com>
 <52b531a7092a8bd09f7ade52fb17b0cee68ffd8a.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <7574d509-7aed-ef8e-265f-6220f865d8e0@redhat.com>
Date:   Thu, 16 Jan 2020 09:57:19 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <52b531a7092a8bd09f7ade52fb17b0cee68ffd8a.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/1/15 22:24, Jeff Layton wrote:
> On Tue, 2020-01-14 at 22:44 -0500, xiubli@redhat.com wrote:
[...]
>> +/*
>> + * Counts the cap metric.
>> + */
>> +void __ceph_caps_metric(struct ceph_inode_info *ci, int mask)
>> +{
>> +	int have = ci->i_snap_caps;
>> +	struct ceph_mds_session *s;
>> +	struct ceph_cap *cap;
>> +	struct rb_node *p;
>> +	bool skip_auth = false;
>> +
>> +	if (mask <= 0)
>> +		return;
>> +
>> +	/* Counts the snap caps metric in the auth cap */
>> +	if (ci->i_auth_cap) {
>> +		cap = ci->i_auth_cap;
>> +		if (have) {
>> +			have |= cap->issued;
>> +
>> +			dout("%s %p cap %p issued %s, mask %s\n", __func__,
>> +			     &ci->vfs_inode, cap, ceph_cap_string(cap->issued),
>> +			     ceph_cap_string(mask));
>> +
>> +			s = ceph_get_mds_session(cap->session);
>> +			if (s) {
>> +				if (mask & have)
>> +					percpu_counter_inc(&s->i_caps_hit);
>> +				else
>> +					percpu_counter_inc(&s->i_caps_mis);
>> +				ceph_put_mds_session(s);
>> +			}
>> +			skip_auth = true;
>> +		}
>> +	}
>> +
>> +	if ((mask & have) == mask)
>> +		return;
>> +
>> +	/* Checks others */
>
> Iterating over i_caps requires that you hold the i_ceph_lock. Some
> callers of __ceph_caps_metric already hold it but some of the callers
> don't.
>
> The simple fix would be to wrap this function in another that takes and
> drops the i_ceph_lock before calling this one. It would also be good to
> add this at the top of this function as well:
>
> 	lockdep_assert_held(&ci->i_ceph_lock);

Yeah, let fix it using the simple way for now.


>
> The bad part is that this does mean adding in extra spinlocking to some
> of these codepaths, which is less than ideal. Eventually, I think we
> ought to convert the cap handling to use RCU and move the i_caps tree to
> a linked list. That would allow us to avoid a lot of the locking for
> stuff like this, and it never has _that_ many entries to where a tree
> really matters.
>
>> +	for (p = rb_first(&ci->i_caps); p; p = rb_next(p)) {
>> +		cap = rb_entry(p, struct ceph_cap, ci_node);
>> +		if (!__cap_is_valid(cap))
>> +			continue;
>> +
>> +		if (skip_auth && cap == ci->i_auth_cap)
>> +			continue;
>> +
>> +		dout("%s %p cap %p issued %s, mask %s\n", __func__,

[...]
>> @@ -2603,6 +2671,8 @@ static int try_get_cap_refs(struct inode *inode, int need, int want,
>>   		spin_lock(&ci->i_ceph_lock);
>>   	}
>>   
>> +	__ceph_caps_metric(ci, need);
>> +
> Should "want" also count toward hits and misses here? IOW:
>
> 	__ceph_caps_metric(ci, need | want);
>
> ?

Yeah, this makes sense.


>
[...]
>> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
>> index 1e6cdf2dfe90..b32aba4023b3 100644
>> --- a/fs/ceph/file.c
>> +++ b/fs/ceph/file.c
>> @@ -393,6 +393,7 @@ int ceph_open(struct inode *inode, struct file *file)
>>   		     inode, fmode, ceph_cap_string(wanted),
>>   		     ceph_cap_string(issued));
>>   		__ceph_get_fmode(ci, fmode);
>> +		__ceph_caps_metric(ci, fmode);
> This looks wrong. fmode is not a cap mask.
>
It should be "wanted" here.

Thanks

