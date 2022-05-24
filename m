Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A047F53204A
	for <lists+ceph-devel@lfdr.de>; Tue, 24 May 2022 03:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232695AbiEXBc3 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 23 May 2022 21:32:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbiEXBc2 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 23 May 2022 21:32:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D96F4427CD
        for <ceph-devel@vger.kernel.org>; Mon, 23 May 2022 18:32:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653355945;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mDqY6e/ZCTT5vbybB6QpEFM89saOLe+qmuOxqy77J64=;
        b=iPmwtRWwuDrTCEumZJpjOaodb+/so5dfUN6p+ACvGA6jFckc0OZx19m+xb2bbcB4hx4d0P
        3EzwJc5UjXQnHGl1liH8ZwAilta9lyvRs+04iueyX3LyM9K+vJ/zEgpBpLZTK2+xSszpZB
        sGuNyD8PC7z2lDL2gDksmPUFl/g16ng=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-558-rxzuHvCfOF2Od9f_yDz07w-1; Mon, 23 May 2022 21:32:24 -0400
X-MC-Unique: rxzuHvCfOF2Od9f_yDz07w-1
Received: by mail-pj1-f70.google.com with SMTP id gn21-20020a17090ac79500b001dc8a800410so556642pjb.0
        for <ceph-devel@vger.kernel.org>; Mon, 23 May 2022 18:32:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=mDqY6e/ZCTT5vbybB6QpEFM89saOLe+qmuOxqy77J64=;
        b=F8OwoLvUlpaSvpjT2Kbdp62sWfPm/P3l/diIdS95fveJnSxa2y0ssTOXQc3X9JtaQb
         CHshVzVdZXt4EG3Iegs/RqcFxn2nYN6mYGbxDfV+IazkGagSMzzbTJ6PmNJuiJu/ZoHj
         kRA2RVltGQCDBlsUnRSQ3TH0zpBQsMl+gVParYJ+VWe95q0C6r4UU8qZnRuqYsSqQnRu
         BYBUZbAACaU7ETrWApHJc62YsW0YOzSHauqXGN5Jyq2J/uzHAuDTVLLgoltlva5SdvFf
         Kmfii/auQmrf0ElghrUnkUY33Eyn75QDQJjaMgz+oLDzh29NN5JBauGdtVSfGOuAJNgM
         5zTw==
X-Gm-Message-State: AOAM531n+QYhiB6DnAXnyLTXvuj568o96iy/bkNUgs1y3FXbBi/0dvZP
        h9VCLkKecOYoc200yKLm6L4cC1MxYwjVgYlJpzGuf/LAhdELnpDdaRbE9I4c2Fh6Ng+Ks/7ZE8w
        CQkrwekdAfYkxM2luKBjF3g==
X-Received: by 2002:a17:90b:33ca:b0:1dc:e5b8:482b with SMTP id lk10-20020a17090b33ca00b001dce5b8482bmr1907549pjb.165.1653355943609;
        Mon, 23 May 2022 18:32:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxE4PFaKoyH4N/WVGpnU5+sYV8dbMj6GNSkjOf7FxYsNhFUq1QPHd7EEfxpYHEOMscQ1+Qy9w==
X-Received: by 2002:a17:90b:33ca:b0:1dc:e5b8:482b with SMTP id lk10-20020a17090b33ca00b001dce5b8482bmr1907529pjb.165.1653355943372;
        Mon, 23 May 2022 18:32:23 -0700 (PDT)
Received: from [10.72.12.81] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x64-20020a628643000000b0050e006279bfsm7707332pfd.137.2022.05.23.18.32.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 May 2022 18:32:22 -0700 (PDT)
Subject: Re: [PATCH v5 1/2] fs/dcache: add d_compare() helper support
To:     Matthew Wilcox <willy@infradead.org>
Cc:     jlayton@kernel.org, idryomov@gmail.com, viro@zeniv.linux.org.uk,
        vshankar@redhat.com, ceph-devel@vger.kernel.org, arnd@arndb.de,
        mcgrof@kernel.org, akpm@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220519101847.87907-1-xiubli@redhat.com>
 <20220519101847.87907-2-xiubli@redhat.com>
 <YovqeybXUKEmhvsi@casper.infradead.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <2bda8367-0f85-027c-33ef-6d631c791c75@redhat.com>
Date:   Tue, 24 May 2022 09:32:14 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YovqeybXUKEmhvsi@casper.infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 5/24/22 4:11 AM, Matthew Wilcox wrote:
> On Thu, May 19, 2022 at 06:18:45PM +0800, Xiubo Li wrote:
>> Reviewed-by: Jeff Layton <jlayton@kernel.org>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ... empty commit message?

Will add it.

Thanks.


>> ---
>>   fs/dcache.c            | 15 +++++++++++++++
>>   include/linux/dcache.h |  2 ++
>>   2 files changed, 17 insertions(+)
>>
>> diff --git a/fs/dcache.c b/fs/dcache.c
>> index 93f4f5ee07bf..95a72f92a94b 100644
>> --- a/fs/dcache.c
>> +++ b/fs/dcache.c
>> @@ -2262,6 +2262,21 @@ static inline bool d_same_name(const struct dentry *dentry,
>>   				       name) == 0;
>>   }
>>   
>> +/**
>> + * d_compare - compare dentry name with case-exact name
>> + * @parent: parent dentry
>> + * @dentry: the negative dentry that was passed to the parent's lookup func
>> + * @name:   the case-exact name to be associated with the returned dentry
>> + *
>> + * Return: 0 if names are same, or 1
>> + */
>> +bool d_compare(const struct dentry *parent, const struct dentry *dentry,
>> +	       const struct qstr *name)
>> +{
>> +	return !d_same_name(dentry, parent, name);
>> +}
>> +EXPORT_SYMBOL(d_compare);
>> +
>>   /**
>>    * __d_lookup_rcu - search for a dentry (racy, store-free)
>>    * @parent: parent dentry
>> diff --git a/include/linux/dcache.h b/include/linux/dcache.h
>> index f5bba51480b2..444b2230e5c3 100644
>> --- a/include/linux/dcache.h
>> +++ b/include/linux/dcache.h
>> @@ -233,6 +233,8 @@ extern struct dentry * d_alloc_parallel(struct dentry *, const struct qstr *,
>>   					wait_queue_head_t *);
>>   extern struct dentry * d_splice_alias(struct inode *, struct dentry *);
>>   extern struct dentry * d_add_ci(struct dentry *, struct inode *, struct qstr *);
>> +extern bool d_compare(const struct dentry *parent, const struct dentry *dentry,
>> +		      const struct qstr *name);
>>   extern struct dentry * d_exact_alias(struct dentry *, struct inode *);
>>   extern struct dentry *d_find_any_alias(struct inode *inode);
>>   extern struct dentry * d_obtain_alias(struct inode *);
>> -- 
>> 2.36.0.rc1
>>

