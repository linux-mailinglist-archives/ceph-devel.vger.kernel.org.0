Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29F0B741E48
	for <lists+ceph-devel@lfdr.de>; Thu, 29 Jun 2023 04:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231752AbjF2CdU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 28 Jun 2023 22:33:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230382AbjF2CdS (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 28 Jun 2023 22:33:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95F33213D
        for <ceph-devel@vger.kernel.org>; Wed, 28 Jun 2023 19:32:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688005946;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XRWtzMPMUezEVjsw+8r8nK2CTGu4NLnnvGhPsdjmqK4=;
        b=dVp5j/Q2p4O8fBfejRLDTIxYoJ5zesgbIvymChVEV4W56jtsdqCzpsy6pRJEmZHDWAT7iE
        r6n+2CMkaR8SqFDexqYRaPujblJEcDLtoCGyU2M2CruD/QTwyMlbdQdavS7ajdZVObmJfq
        xHeyyoLB3atVwCIdvORDYuQk4j8Tr7c=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-534-0xgKM1PCNpy1JTCPtt-yhA-1; Wed, 28 Jun 2023 22:32:25 -0400
X-MC-Unique: 0xgKM1PCNpy1JTCPtt-yhA-1
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-262cf62e9b4so196214a91.0
        for <ceph-devel@vger.kernel.org>; Wed, 28 Jun 2023 19:32:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688005944; x=1690597944;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XRWtzMPMUezEVjsw+8r8nK2CTGu4NLnnvGhPsdjmqK4=;
        b=HnTDEPGYw6AtpnT3hQsrxMoxjq4rZZXrl54VOyVnoM7RBL3bpyAZ+F00DY1hYozNsW
         OMk1lHwZdP2M7CmFle3e+kseKWL6X8RcodCg70gzJPSszPPMjWjkecSiUpcbKc/GolAC
         zBvAiUj2sAAjy1Er7P1NWTLjWMQNcaPfP+sR7iBCKnaPF8c+3VzVo2/KtWc4imc8VGqG
         HMKrWw/KqfHhd1OSTKuSub5WvtErlRHxyS7Ldf+/eSoLMtRXXLuJ5msTq8knq0spmYsi
         DoNixxjZHh/IgnaDIx4h3tQA5sWlfyoLZRasedzzGAkbGUks39lBHWQSLZ71jGjrOKjx
         +PWQ==
X-Gm-Message-State: AC+VfDwvxUeI0f3Csc1dwZGMpEHMvv6UCScnd9xKBzIG1S9SV0ozr61o
        Ck7tGvUZJE+ji0j5vmxjQAOTbQTqc3bc5motH3rMg9jatB8pGVNAu7/AoKyn6o6yqZM/04O4qNA
        momATTYjEG3CgS7LYnzwdGQ==
X-Received: by 2002:a17:90b:4b88:b0:262:b22b:d2e8 with SMTP id lr8-20020a17090b4b8800b00262b22bd2e8mr16558964pjb.17.1688005943995;
        Wed, 28 Jun 2023 19:32:23 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6DTyhlenNTkQdTN0W1mnsOTgjTSsM6B7ovKyybgepxDmpuBdiK1yUIU+S7YpNin5DtWdzN+g==
X-Received: by 2002:a17:90b:4b88:b0:262:b22b:d2e8 with SMTP id lr8-20020a17090b4b8800b00262b22bd2e8mr16558959pjb.17.1688005943731;
        Wed, 28 Jun 2023 19:32:23 -0700 (PDT)
Received: from [10.72.13.91] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x2-20020a17090a294200b00262ca945cecsm8757960pjf.54.2023.06.28.19.32.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Jun 2023 19:32:23 -0700 (PDT)
Message-ID: <ed028c72-12c4-6267-cf01-abf25496faf3@redhat.com>
Date:   Thu, 29 Jun 2023 10:32:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v2] ceph: don't let check_caps skip sending responses for
 revoke msgs
Content-Language: en-US
To:     Patrick Donnelly <pdonnell@redhat.com>
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, mchangir@redhat.com, stable@vger.kernel.org
References: <20230627235709.201132-1-xiubli@redhat.com>
 <CA+2bHPYSRSoYqT4RV6KNUS2X6kNVC7f0JdQzyknh6i75PonJYA@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CA+2bHPYSRSoYqT4RV6KNUS2X6kNVC7f0JdQzyknh6i75PonJYA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 6/29/23 09:01, Patrick Donnelly wrote:
> Patch looks good to me. Sorry I must nitpick the commit message wording:
>
> If a client sends out a cap update dropping caps with the prior 'seq' just
> before an incoming cap revoke request, then the client may drop the revoke
> because it believes it's already released the requested capabilities.
> This causes
> the MDS to wait indefinitely for the client to respond to the revoke.
> It's therefore always a good idea to ack the cap revoke request with
> the bumped up 'seq'.

Updated it by sending out the V3.

Thanks

- Xiubo


> On Tue, Jun 27, 2023 at 7:59 PM <xiubli@redhat.com> wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> If a client sends out a cap-update request with the old 'seq' just
>> before a pending cap revoke request, then the MDS might miscalculate
>> the 'seqs' and caps. It's therefore always a good idea to ack the
>> cap revoke request with the bumped up 'seq'.
>>
>> Cc: stable@vger.kernel.org
>> Cc: Patrick Donnelly <pdonnell@redhat.com>
>> URL: https://tracker.ceph.com/issues/61782
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>
>> V2:
>> - Rephrased the commit comment for better understanding from Milind
>>
>>
>>   fs/ceph/caps.c | 9 +++++++++
>>   1 file changed, 9 insertions(+)
>>
>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>> index 1052885025b3..eee2fbca3430 100644
>> --- a/fs/ceph/caps.c
>> +++ b/fs/ceph/caps.c
>> @@ -3737,6 +3737,15 @@ static void handle_cap_grant(struct inode *inode,
>>          }
>>          BUG_ON(cap->issued & ~cap->implemented);
>>
>> +       /* don't let check_caps skip sending a response to MDS for revoke msgs */
>> +       if (le32_to_cpu(grant->op) == CEPH_CAP_OP_REVOKE) {
>> +               cap->mds_wanted = 0;
>> +               if (cap == ci->i_auth_cap)
>> +                       check_caps = 1; /* check auth cap only */
>> +               else
>> +                       check_caps = 2; /* check all caps */
>> +       }
>> +
>>          if (extra_info->inline_version > 0 &&
>>              extra_info->inline_version >= ci->i_inline_version) {
>>                  ci->i_inline_version = extra_info->inline_version;
>> --
>> 2.40.1
>>
>

