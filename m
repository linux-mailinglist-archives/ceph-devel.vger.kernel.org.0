Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9809B54AD09
	for <lists+ceph-devel@lfdr.de>; Tue, 14 Jun 2022 11:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354096AbiFNJMy (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 14 Jun 2022 05:12:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237934AbiFNJMu (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 14 Jun 2022 05:12:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3C5222DD7F
        for <ceph-devel@vger.kernel.org>; Tue, 14 Jun 2022 02:12:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655197968;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ymS22PDBV05UdDjqwbym9nV4Rhn2uWneERbh1AjmMMo=;
        b=YrlL27jNB3qG3Q96yfkbPLno0no1WQBuYvoCnsnmcJGPzhPoGOrG+Xvn896tRLPjerqm+r
        vF1eqNpDFdiHq1fDh9YiqG+qk8kVKEAlH+BUvL6ycqLjBluZHG49uHDr0EZEiHjnkh3nDA
        m4pCajuhE5Pkqx3AAujNvxI1LFEteec=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-426-uTta4sDhMfOiLVVNM7GeIw-1; Tue, 14 Jun 2022 05:12:47 -0400
X-MC-Unique: uTta4sDhMfOiLVVNM7GeIw-1
Received: by mail-pl1-f198.google.com with SMTP id c10-20020a170903234a00b00168b5f7661bso4563617plh.6
        for <ceph-devel@vger.kernel.org>; Tue, 14 Jun 2022 02:12:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=ymS22PDBV05UdDjqwbym9nV4Rhn2uWneERbh1AjmMMo=;
        b=uoQ85CIpc2kuEO75rhP90hkH889ufK+r7g3JQNjqS/lFyumEg7lH1x1xusR67GSqbe
         m33SAT970Eyzdn5mOrlHhkZrkCFoVPevSXqCO5PqBstVh/EQSUkpqz96H7xdASYYL+Dg
         5xK+4T/X7ef2opDwL6FlOR71UF/uQUK2HtwJP+daoRTnchXXaewXzSv+J4kJdd1mL9Dw
         L376DYtfAqmohVJQCvb3NH4iLcck5P80kRQo1jVJUuh7RYLOv436+9FM+7GWyZV1s+x5
         +SpuKHANXZlyDlT6RaCA9bTVmca9+Aqfhrvj3zJSb0JYixuFezUbcTh625tyMxFPM03z
         SvfA==
X-Gm-Message-State: AOAM532uzRdUtFUQgFYKe0OKi1TYsHgLLZhHTSvpxZwwxPBUNNrolxhp
        ImFKvF6tfeohzoTVyqRwyW1aUgjTN8j+S3nDiOUmyIpaxg0E4+0FoUgV08+LLUQt7P1E3SPGt9q
        +k2ypPNXgwMUVnaXga880WNNl3pZsExb1KyWx5n8d4hvynh+5cVmSq5jIdOX8Zxfr8HO0SkE=
X-Received: by 2002:aa7:9f84:0:b0:51b:b64d:fc69 with SMTP id z4-20020aa79f84000000b0051bb64dfc69mr3812908pfr.7.1655197965988;
        Tue, 14 Jun 2022 02:12:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyW7ocnav03gr+v9PjvWker0uC6ro5Y67bNqpTP/B704miKsZY65QxvWQKXtqO9nwyKwLljOw==
X-Received: by 2002:aa7:9f84:0:b0:51b:b64d:fc69 with SMTP id z4-20020aa79f84000000b0051bb64dfc69mr3812871pfr.7.1655197965553;
        Tue, 14 Jun 2022 02:12:45 -0700 (PDT)
Received: from [10.72.12.99] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j187-20020a62c5c4000000b0051c31cc3ca7sm7027370pfg.4.2022.06.14.02.12.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jun 2022 02:12:44 -0700 (PDT)
Subject: Re: [PATCH 2/2] ceph: update the auth cap when the async create req
 is forwarded
To:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>
Cc:     jlayton@kernel.org, idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org
References: <20220610043140.642501-1-xiubli@redhat.com>
 <20220610043140.642501-3-xiubli@redhat.com> <87r13seed5.fsf@brahms.olymp>
 <4eb44a0b-f7e9-683d-8317-15cf959a570a@redhat.com>
 <87mtef63py.fsf@brahms.olymp>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <741daf3d-1076-705d-3898-ee8658b6a062@redhat.com>
Date:   Tue, 14 Jun 2022 17:12:39 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <87mtef63py.fsf@brahms.olymp>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 6/14/22 4:36 PM, Luís Henriques wrote:
> Xiubo Li <xiubli@redhat.com> writes:
>
>> On 6/14/22 12:07 AM, Luís Henriques wrote:
>>> Xiubo Li <xiubli@redhat.com> writes:
>>>
>>>> For async create we will always try to choose the auth MDS of frag
>>>> the dentry belonged to of the parent directory to send the request
>>>> and ususally this works fine, but if the MDS migrated the directory
>>>> to another MDS before it could be handled the request will be
>>>> forwarded. And then the auth cap will be changed.
>>>>
>>>> We need to update the auth cap in this case before the request is
>>>> forwarded.
>>>>
>>>> URL: https://tracker.ceph.com/issues/55857
>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>>> ---
>>>>    fs/ceph/file.c       | 12 +++++++++
>>>>    fs/ceph/mds_client.c | 58 ++++++++++++++++++++++++++++++++++++++++++++
>>>>    fs/ceph/super.h      |  2 ++
>>>>    3 files changed, 72 insertions(+)
>>>>
>>>> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
>>>> index 0e82a1c383ca..54acf76c5e9b 100644
>>>> --- a/fs/ceph/file.c
>>>> +++ b/fs/ceph/file.c
>>>> @@ -613,6 +613,7 @@ static int ceph_finish_async_create(struct inode *dir, struct inode *inode,
>>>>    	struct ceph_mds_reply_inode in = { };
>>>>    	struct ceph_mds_reply_info_in iinfo = { .in = &in };
>>>>    	struct ceph_inode_info *ci = ceph_inode(dir);
>>>> +	struct ceph_dentry_info *di = ceph_dentry(dentry);
>>>>    	struct timespec64 now;
>>>>    	struct ceph_string *pool_ns;
>>>>    	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(dir->i_sb);
>>>> @@ -709,6 +710,12 @@ static int ceph_finish_async_create(struct inode *dir, struct inode *inode,
>>>>    		file->f_mode |= FMODE_CREATED;
>>>>    		ret = finish_open(file, dentry, ceph_open);
>>>>    	}
>>>> +
>>>> +	spin_lock(&dentry->d_lock);
>>>> +	di->flags &= ~CEPH_DENTRY_ASYNC_CREATE;
>>>> +	wake_up_bit(&di->flags, CEPH_DENTRY_ASYNC_CREATE_BIT);
>>>> +	spin_unlock(&dentry->d_lock);
>>> Question: shouldn't we initialise 'di' *after* grabbing ->d_lock?  Ceph
>>> code doesn't seem to be consistent with this regard, but my understanding
>>> is that doing it this way is racy.  And if so, some other places may need
>>> fixing.
>> Yeah, it should be.
>>
>> BTW, do you mean some where like this:
>>
>> if (!test_bit(CEPH_DENTRY_ASYNC_UNLINK_BIT, &di->flags))
>>
>> ?
>>
>> If so, it's okay and no issue here.
> No, I meant patterns like the one above, where you initialize a pointer to
> a struct ceph_dentry_info (from ->d_fsdata) and then grab ->d_lock.  For
> example, in splice_dentry().  I think there are a few other places where
> this pattern can be seen, even in other filesystems.  So maybe it's not
> really an issue, and that's why I asked: does this lock really protects
> accesses to ->d_fsdata?

Okay, get it.

I think it should be okay, the dentry reference has been increased 
during these. In theory the ->d_fsdata shouldn't be released while we 
are accessing it if I didn't miss something important.


-- Xiubo


>
> Cheers,

