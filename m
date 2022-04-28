Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 684F05133DC
	for <lists+ceph-devel@lfdr.de>; Thu, 28 Apr 2022 14:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346367AbiD1MnJ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 28 Apr 2022 08:43:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346366AbiD1MnG (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 28 Apr 2022 08:43:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 80347AF1E8
        for <ceph-devel@vger.kernel.org>; Thu, 28 Apr 2022 05:39:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651149591;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HsdU9AGgUCeBmr2WlvVMi/Mp7HdI09fVUn2pyPYYbqM=;
        b=eF6v2s4C02G2tILOIPl3R0VHM+etCzHXSDIFGHexzrC5RME3nsvN40+dTKX8gitc8sIZuF
        0cEIVCyY3F3SmYjdq1sXrB3VlBS61EFuh1PbayA7k3MUahq94hm9MvI13Tjv4R3MeAfDkJ
        /A04Ydx47OD2BqZb4AaTNB4utFnNYU8=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-424-cQv3Ij1CPRSKVYayclKULQ-1; Thu, 28 Apr 2022 08:39:50 -0400
X-MC-Unique: cQv3Ij1CPRSKVYayclKULQ-1
Received: by mail-pf1-f200.google.com with SMTP id k14-20020aa790ce000000b0050d3b201122so2706722pfk.20
        for <ceph-devel@vger.kernel.org>; Thu, 28 Apr 2022 05:39:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=HsdU9AGgUCeBmr2WlvVMi/Mp7HdI09fVUn2pyPYYbqM=;
        b=kkE9o2Adr665myAvORmu7FBq2c2mEW6xrDz2pUgNxbes1bELE/9B5U47iwOYyzy7gl
         PFnXN8+WNTPCyAsCAqJvsXT7tG++HFsxTBNVlQg/6Tq5O5hH3F+mm2t8bO6C/GqCgggg
         W4oiC9xThuVmVaKSaNn8YQIpya/ffd/xH4WjHKCd2Ly7zS0a/+zRr0E/ePBQIPwDvFXO
         ctn1NKXoyIKVTOrgc2teu7r02iQ4UXJo+GAsEXIzL1KnkE4g8nFKzwR5R7eiOmkB8a4m
         0ktr5DD2v/jbu8Mv0tjzXH7aW+P3YZ2yjU+aBUTpbIW7pci3DN9o68WRI+3npBzLex9E
         Iegw==
X-Gm-Message-State: AOAM532wMboi6EVNpDyMeIETuRRO0sJnO3DnhggJGko8subQFWmVqz+l
        Y0tFZRwhXPHYLS8hvK5JKY2I/T4o/85qC7yl1k6nIkNEjD5C683J/x5JjAxpgt1b3iZEERLH9L0
        AeqjtzxvQitbZs729qLFcFpV1ThrkDVDyT4b5fLgqhqVNaWy1LyOL681oFyGv2F7rU1v2+e8=
X-Received: by 2002:a17:902:8546:b0:15b:6752:d3fa with SMTP id d6-20020a170902854600b0015b6752d3famr33774573plo.89.1651149588880;
        Thu, 28 Apr 2022 05:39:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJygoobqDY1AaiQQxZhL7L0Z8nvFmXW+zVl4SS8mSobgsB/cNUO8mnqQoyu06EdMHwyXzbYbvQ==
X-Received: by 2002:a17:902:8546:b0:15b:6752:d3fa with SMTP id d6-20020a170902854600b0015b6752d3famr33774546plo.89.1651149588556;
        Thu, 28 Apr 2022 05:39:48 -0700 (PDT)
Received: from [10.72.12.57] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p23-20020a637f57000000b003c14af5062fsm2870702pgn.71.2022.04.28.05.39.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Apr 2022 05:39:47 -0700 (PDT)
Subject: Re: [PATCH] ceph: don't retain the caps if they're being revoked and
 not used
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
References: <20220428121318.43125-1-xiubli@redhat.com>
 <4d9eaa5f86ab1d4d4b33b0308de12d9384b0daba.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <e7e02ec9-6d16-40c9-2db8-daf59880b6dd@redhat.com>
Date:   Thu, 28 Apr 2022 20:39:42 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <4d9eaa5f86ab1d4d4b33b0308de12d9384b0daba.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 4/28/22 8:29 PM, Jeff Layton wrote:
> On Thu, 2022-04-28 at 20:13 +0800, Xiubo Li wrote:
>> For example if the Frwcb caps are being revoked, but only the Fr
>> caps is still being used then the kclient will skip releasing them
>> all. But in next turn if the Fr caps is ready to be released the
>> Fw caps maybe just being used again. So in corner case, such as
>> heavy load IOs, the revocation maybe stuck for a long time.
>>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/caps.c | 7 +++++++
>>   1 file changed, 7 insertions(+)
>>
>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>> index 0c0c8f5ae3b3..7eb5238941fc 100644
>> --- a/fs/ceph/caps.c
>> +++ b/fs/ceph/caps.c
>> @@ -1947,6 +1947,13 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
>>   
>>   	/* The ones we currently want to retain (may be adjusted below) */
>>   	retain = file_wanted | used | CEPH_CAP_PIN;
>> +
>> +	/*
>> +	 * Do not retain the capabilities if they are under revoking
>> +	 * but not used, this could help speed up the revoking.
>> +	 */
>> +	retain &= ~((revoking & retain) & ~used);
>> +
>>   	if (!mdsc->stopping && inode->i_nlink > 0) {
>>   		if (file_wanted) {
>>   			retain |= CEPH_CAP_ANY;       /* be greedy */
> Actually maybe something like this would be simpler to understand?
>
> /* Retain any caps that are actively in use */
> retain = used | CEPH_CAP_PIN;
>
> /* Also retain caps wanted by open files, if they aren't being revoked */
> retain |= (file_wanted & ~revoking);

Yeah, sounds good, let me try to simplify it to make it more readable.

THanks.


