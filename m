Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E46F84DC4D8
	for <lists+ceph-devel@lfdr.de>; Thu, 17 Mar 2022 12:28:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233019AbiCQLaN (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 17 Mar 2022 07:30:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiCQLaM (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 17 Mar 2022 07:30:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E655D39BAD
        for <ceph-devel@vger.kernel.org>; Thu, 17 Mar 2022 04:28:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647516536;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cPlGxTVc5l/iXzGYZHS8T7PaUjXYnLI4OTLYSgTvVj4=;
        b=BlT5FEWXNx3TPT4oD6XGziA6140naL+WDZWXfjuXo/y3ecjl9yD3LbHVoF7ks6zu4RDR7i
        wOEn0NdSIGddqGZxKrcsM/xjhxETt1gQx41Gwi9RwpBvhWIIi94RrTtLpsANSUpbOrGucm
        5AnC8NaJUxvitIsCTuaf769CRGz0C8U=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-368-5OE_5qR-OPKCuiHY3i6xRQ-1; Thu, 17 Mar 2022 07:28:55 -0400
X-MC-Unique: 5OE_5qR-OPKCuiHY3i6xRQ-1
Received: by mail-pg1-f197.google.com with SMTP id t62-20020a635f41000000b0037c9ae5fb8bso1637571pgb.19
        for <ceph-devel@vger.kernel.org>; Thu, 17 Mar 2022 04:28:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=cPlGxTVc5l/iXzGYZHS8T7PaUjXYnLI4OTLYSgTvVj4=;
        b=3qfDU7sKG5JcDZf9Inr+b9qJWISt0HLDBt51kLDe2SDompnYZINCxAxF2Rqug5vDdm
         WO2MAa1CIrupYGD0OdjuNUvEv+zQYvHId63gAj5ma6y8a1z3wlfsVZPPLXY6UqLxPv7Y
         RnFCbn1UcsZaOG5AmkXntN4X+1cUrvIJgy2R1EaUuTctiMVGZS9esBNfIGHefd2NOJj5
         nLMlsXwNs+AdDuVtd9JAFR8xJNgMcSKNodDdpFR3P1H1PJkePKQ0sMHJScdwAUgZBNab
         xrDpri4UggmH7VWYGDha0rRyRhzs5gZ8PL4OZ5+0mojEVrfiihRiVj+stCJKpVe0Rb+p
         ad3g==
X-Gm-Message-State: AOAM533Rj1ISBC+2A9MKO8twJFvfOvaRperI9ED/P7po1NvK/VWiB+4p
        Gq8BkdoPPLl217IgLFFkiwlaTZKA2CFPWv0H5fe5INsgnWxzLeuPBoS3vRcI4Nj4fVJ6tJ1BzQm
        LcbwOnHICiADeuza2XT8i0w==
X-Received: by 2002:a17:903:40c7:b0:153:b0d:f8a0 with SMTP id t7-20020a17090340c700b001530b0df8a0mr4572615pld.156.1647516533192;
        Thu, 17 Mar 2022 04:28:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzwiTpMxihvo30z7tGf/OsomJLRyOiNBGyqOMEI8ev+G3klDSKKuINhyVnXWRjTEPzQQO4+AQ==
X-Received: by 2002:a17:903:40c7:b0:153:b0d:f8a0 with SMTP id t7-20020a17090340c700b001530b0df8a0mr4572573pld.156.1647516532561;
        Thu, 17 Mar 2022 04:28:52 -0700 (PDT)
Received: from [10.72.12.110] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id oo17-20020a17090b1c9100b001bf0ccc59c2sm10086923pjb.16.2022.03.17.04.28.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Mar 2022 04:28:51 -0700 (PDT)
Subject: Re: [RFC PATCH v2 0/3] ceph: add support for snapshot names
 encryption
To:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
References: <20220315161959.19453-1-lhenriques@suse.de>
 <5b53e812-d49b-45f0-1219-3dbc96febbc1@redhat.com>
 <329abedd9d9938de95bf4f5600acdcd6a846e6be.camel@kernel.org>
 <3c8b78c4-5392-b81c-e76f-64fcce4f3c0f@redhat.com>
 <87wngshlzb.fsf@brahms.olymp>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <40c9ebed-2c49-3a91-7893-5d0c7f124ead@redhat.com>
Date:   Thu, 17 Mar 2022 19:28:45 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <87wngshlzb.fsf@brahms.olymp>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 3/17/22 7:11 PM, Luís Henriques wrote:
> Xiubo Li <xiubli@redhat.com> writes:
>
>> On 3/17/22 6:01 PM, Jeff Layton wrote:
>>> I'm not sure we want to worry about .snap directories here since they
>>> aren't "real". IIRC, snaps are inherited from parents too, so you could
>>> do something like
>>>
>>>       mkdir dir1
>>>       mkdir dir1/.snap/snap1
>>>       mkdir dir1/dir2
>>>       fscrypt encrypt dir1/dir2
>>>
>>> There should be nothing to prevent encrypting dir2, but I'm pretty sure
>>> dir2/.snap will not be empty at that point.
>> If we don't take care of this. Then we don't know which snapshots should do
>> encrypt/dencrypt and which shouldn't when building the path in lookup and when
>> reading the snapdir ?
> In my patchset (which I plan to send a new revision later today, I think I
> still need to rebase it) this is handled by using the *real* snapshot
> parent inode.  If we're decrypting/encrypting a name for a snapshot that
> starts with a '_' character, we first find the parent inode for that
> snapshot and only do the operation if that parent is encrypted.

Yeah, this is correct. And in my previous patches it worked well.


>
> In the other email I suggested that we could prevent enabling encryption
> in a directory when there are snapshots above in the hierarchy.

I think this is incorrect. Or once there has a snapshot in the root 
directory, then you couldn't enable encryption any more in any subdirs ...


>   But now
> that I think more about it, it won't solve any problem because you could
> create those snapshots later and then you would still need to handle these
> (non-encrypted) "_name_xxxx" snapshots anyway.

You only need to take care of the *real* or local snapshots.

-- Xiubo

>
> Cheers,

