Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15CE63F558D
	for <lists+ceph-devel@lfdr.de>; Tue, 24 Aug 2021 03:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233522AbhHXBou (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 23 Aug 2021 21:44:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52864 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232186AbhHXBou (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 23 Aug 2021 21:44:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629769446;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BehHRXFGmJaQYpwqmuMypRfhwJ4TNcfBNA4P+B+yv9s=;
        b=gB7F74oxy0JoKoarwVJwlXIoFKFZhQk2v6kU/lEwTZPGKxs3fSOJooF0lRGHavwCRAYTTi
        vwGrkBZa7w2a+PHsB3NUJf8xQ1kuneKzqi2qIsfTVS7WSSfkgxKR7TCxTE2MfDvjk3Trm8
        VVPjaZvsHUXhaSzjKcYUTVs/2LtTMuY=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-449-pOlcNZKLMAOrf7nublRmlA-1; Mon, 23 Aug 2021 21:44:05 -0400
X-MC-Unique: pOlcNZKLMAOrf7nublRmlA-1
Received: by mail-pg1-f200.google.com with SMTP id h10-20020a65404a000000b00253122e62a0so166717pgp.0
        for <ceph-devel@vger.kernel.org>; Mon, 23 Aug 2021 18:44:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=BehHRXFGmJaQYpwqmuMypRfhwJ4TNcfBNA4P+B+yv9s=;
        b=bidqheAynVk6UqYImBTxQgtbIU1qr/NpsO0tKAKhrF0eSwER8/k449RsU9k9kw13P6
         ylBRd5OK2L2qgYramm+cTUnXnLNAlHr2zVrjTO4zl8tq5f86l+RKUIimpOJxYGkyxpYA
         fs7dut8jjo8/ZNUQgoodzPKK+Y1tEZ5DAxN1cugNGVXhSjxXJnpKzcYTuStxKoEnjJq0
         6tytmRW9jzrkDnYfFrs+8Gb5r5Eojfem6/td3FTSNbfyV1xuogzOjv3CVhXHnQy24xCR
         9KVuvtJ+eVzJGMwKYEwi8Cv/FhW7vHdY/sAONy8LpFNjh9j4XnX947KMJtDX6LwdFnwO
         XMGw==
X-Gm-Message-State: AOAM531tPQ4JgEhVj+SFqS6zjd9v9pNhR9Yi+wBmKevXXKm2joWAafAX
        QS9YloY4piCjM7tqMnz3TPnlkT0tX/7v/XjSuQXm2um0ucGAYNq4Q/8VXmjCtQAjmJaweam5P7n
        Go+j5Zv0mDkPktshpmZPE8Jt1XNKR9Rg+dZ6KgzKj6bPVlDbu1P+l3Kv8bKSn0j50IGqyg9E=
X-Received: by 2002:a05:6a00:1803:b029:3cd:d5c1:f718 with SMTP id y3-20020a056a001803b02903cdd5c1f718mr36661623pfa.22.1629769443809;
        Mon, 23 Aug 2021 18:44:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwHfqT281Rik60UYLt1rsSpqCJLLJomRXYgbBM1A1qiyZK9UM+UUI+/TpfGDsR4jkGM3Hmxdg==
X-Received: by 2002:a05:6a00:1803:b029:3cd:d5c1:f718 with SMTP id y3-20020a056a001803b02903cdd5c1f718mr36661606pfa.22.1629769443464;
        Mon, 23 Aug 2021 18:44:03 -0700 (PDT)
Received: from [10.72.12.33] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 66sm17126606pfu.67.2021.08.23.18.44.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Aug 2021 18:44:03 -0700 (PDT)
Subject: Re: [PATCH 3/3] ceph: don't WARN if we're iterate removing the
 session caps
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <20210818080603.195722-1-xiubli@redhat.com>
 <20210818080603.195722-4-xiubli@redhat.com>
 <ac8b71a9e07be3c21fc5a788932196bda381e637.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <f8b691f4-5000-4165-d196-b21b139fcd7d@redhat.com>
Date:   Tue, 24 Aug 2021 09:43:58 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <ac8b71a9e07be3c21fc5a788932196bda381e637.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 8/23/21 9:59 PM, Jeff Layton wrote:
> On Wed, 2021-08-18 at 16:06 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> For example in case force umounting it will remove all the session
>> caps one by one even it's dirty cap.
>>
>> URL: https://tracker.ceph.com/issues/52295
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/caps.c       | 15 ++++++++-------
>>   fs/ceph/mds_client.c |  4 ++--
>>   fs/ceph/super.h      |  3 ++-
>>   3 files changed, 12 insertions(+), 10 deletions(-)
>>
>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>> index 7def99fbdca6..1ed9b9d57dd3 100644
>> --- a/fs/ceph/caps.c
>> +++ b/fs/ceph/caps.c
>> @@ -1101,7 +1101,7 @@ int ceph_is_any_caps(struct inode *inode)
>>    * caller should hold i_ceph_lock.
>>    * caller will not hold session s_mutex if called from destroy_inode.
>>    */
>> -void __ceph_remove_cap(struct ceph_cap *cap, bool queue_release)
>> +void __ceph_remove_cap(struct ceph_cap *cap, bool queue_release, bool warn)
> I think it'd be better to refactor __ceph_remove_cap so that it has a
> wrapper function that does the WARN_ON_ONCE call under the right
> conditions.
>
> Maybe add a ceph_remove_cap() that does:
>
> 	WARN_ON_ONCE(ci && ci->i_auth_cap == cap &&
> 		     !list_empty(&ci->i_dirty_item) &&
> 		     !mdsc->fsc->blocklisted);
>
> ...and then calls __ceph_remove_cap(). Then you could have the ones that
> set "warn" to false call __ceph_remove_cap() and the others would call
> ceph_remove_cap(). That's at least a little less ugly (and more
> efficient).

Sure, make sense.

> Alternately, I guess you could try to test what state the session is in
> and only warn if it's not being force-unmounted?

I will try this later.

Thanks


>>   {
>>   	struct ceph_mds_session *session = cap->session;
>>   	struct ceph_inode_info *ci = cap->ci;
>> @@ -1121,7 +1121,7 @@ void __ceph_remove_cap(struct ceph_cap *cap, bool queue_release)
>>   	/* remove from inode's cap rbtree, and clear auth cap */
>>   	rb_erase(&cap->ci_node, &ci->i_caps);
>>   	if (ci->i_auth_cap == cap) {
>> -		WARN_ON_ONCE(!list_empty(&ci->i_dirty_item) &&
>> +		WARN_ON_ONCE(warn && !list_empty(&ci->i_dirty_item) &&
>>   			     !mdsc->fsc->blocklisted);
>>   		ci->i_auth_cap = NULL;
>>   	}
>> @@ -1304,7 +1304,7 @@ void __ceph_remove_caps(struct ceph_inode_info *ci)
>>   	while (p) {
>>   		struct ceph_cap *cap = rb_entry(p, struct ceph_cap, ci_node);
>>   		p = rb_next(p);
>> -		__ceph_remove_cap(cap, true);
>> +		__ceph_remove_cap(cap, true, true);
>>   	}
>>   	spin_unlock(&ci->i_ceph_lock);
>>   }
>> @@ -3815,7 +3815,7 @@ static void handle_cap_export(struct inode *inode, struct ceph_mds_caps *ex,
>>   		goto out_unlock;
>>   
>>   	if (target < 0) {
>> -		__ceph_remove_cap(cap, false);
>> +		__ceph_remove_cap(cap, false, true);
>>   		goto out_unlock;
>>   	}
>>   
>> @@ -3850,7 +3850,7 @@ static void handle_cap_export(struct inode *inode, struct ceph_mds_caps *ex,
>>   				change_auth_cap_ses(ci, tcap->session);
>>   			}
>>   		}
>> -		__ceph_remove_cap(cap, false);
>> +		__ceph_remove_cap(cap, false, true);
>>   		goto out_unlock;
>>   	} else if (tsession) {
>>   		/* add placeholder for the export tagert */
>> @@ -3867,7 +3867,7 @@ static void handle_cap_export(struct inode *inode, struct ceph_mds_caps *ex,
>>   			spin_unlock(&mdsc->cap_dirty_lock);
>>   		}
>>   
>> -		__ceph_remove_cap(cap, false);
>> +		__ceph_remove_cap(cap, false, true);
>>   		goto out_unlock;
>>   	}
>>   
>> @@ -3978,7 +3978,8 @@ static void handle_cap_import(struct ceph_mds_client *mdsc,
>>   					ocap->mseq, mds, le32_to_cpu(ph->seq),
>>   					le32_to_cpu(ph->mseq));
>>   		}
>> -		__ceph_remove_cap(ocap, (ph->flags & CEPH_CAP_FLAG_RELEASE));
>> +		__ceph_remove_cap(ocap, (ph->flags & CEPH_CAP_FLAG_RELEASE),
>> +				  true);
>>   	}
>>   
>>   	*old_issued = issued;
>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>> index 0302af53e079..d99ec2618585 100644
>> --- a/fs/ceph/mds_client.c
>> +++ b/fs/ceph/mds_client.c
>> @@ -1636,7 +1636,7 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
>>   	dout("removing cap %p, ci is %p, inode is %p\n",
>>   	     cap, ci, &ci->vfs_inode);
>>   	spin_lock(&ci->i_ceph_lock);
>> -	__ceph_remove_cap(cap, false);
>> +	__ceph_remove_cap(cap, false, false);
>>   	if (!ci->i_auth_cap) {
>>   		struct ceph_cap_flush *cf;
>>   
>> @@ -2008,7 +2008,7 @@ static int trim_caps_cb(struct inode *inode, struct ceph_cap *cap, void *arg)
>>   
>>   	if (oissued) {
>>   		/* we aren't the only cap.. just remove us */
>> -		__ceph_remove_cap(cap, true);
>> +		__ceph_remove_cap(cap, true, true);
>>   		(*remaining)--;
>>   	} else {
>>   		struct dentry *dentry;
>> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
>> index 51ec17d12b26..106ddfd1ce92 100644
>> --- a/fs/ceph/super.h
>> +++ b/fs/ceph/super.h
>> @@ -1142,7 +1142,8 @@ extern void ceph_add_cap(struct inode *inode,
>>   			 unsigned issued, unsigned wanted,
>>   			 unsigned cap, unsigned seq, u64 realmino, int flags,
>>   			 struct ceph_cap **new_cap);
>> -extern void __ceph_remove_cap(struct ceph_cap *cap, bool queue_release);
>> +extern void __ceph_remove_cap(struct ceph_cap *cap, bool queue_release,
>> +			      bool warn);
>>   extern void __ceph_remove_caps(struct ceph_inode_info *ci);
>>   extern void ceph_put_cap(struct ceph_mds_client *mdsc,
>>   			 struct ceph_cap *cap);

