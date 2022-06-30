Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0E37560F70
	for <lists+ceph-devel@lfdr.de>; Thu, 30 Jun 2022 05:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231506AbiF3DFU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 29 Jun 2022 23:05:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231216AbiF3DFP (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 29 Jun 2022 23:05:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D52F33EABC
        for <ceph-devel@vger.kernel.org>; Wed, 29 Jun 2022 20:05:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656558313;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fgssr9lonzemN7LpJiO/O5PwxzLctj9YKkBhgDOfZYA=;
        b=FAW7HIEUTSekHWaw/Rs6VnkJL+CX1tEe/XYqv5UUKyaHJJanEsquFrxfSqcDEWGmiAl5Ky
        E6Mh7dsJmCWCFN+NrK23oCrJQToDalTtGnuPFAe/w8+SC2PnCvWwOxIAtJfP6YF83rzAs5
        QVFdDXW4GiTwSl1BR49TNoiVu9EK+go=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-442-kAGktnmPMKi5o1oYNV-OXw-1; Wed, 29 Jun 2022 23:05:11 -0400
X-MC-Unique: kAGktnmPMKi5o1oYNV-OXw-1
Received: by mail-pf1-f199.google.com with SMTP id f63-20020a623842000000b005252a15e64aso7085517pfa.2
        for <ceph-devel@vger.kernel.org>; Wed, 29 Jun 2022 20:05:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=fgssr9lonzemN7LpJiO/O5PwxzLctj9YKkBhgDOfZYA=;
        b=qhk4Rwv6u+1c3NcvkrAahu8yNsRKUw19SMc4dWeir/v7CNFS7R/UErEQOfEXrU5ETM
         Rxbbs0BLqBqkkJ/38F2SfaA+MziOha38RXdLGmKLGoJBbXZ2Xft8/nHrkQ2kjXjP4jZd
         CSY6GkIdiDvaZWqUtBRXtFCCkJns9hJDt6iNB1nnA9oKZ18BWT540oQaZO0iMfX5HC0M
         zT0rCkuxrZqRx4wHBWDvWiz+vf0/30jnXdgRa8TYccI/1pxCwAiWO4IorZ+ExAYJcCSs
         bM9HScpsFDZrg+ohtesO0ukuOubUYBK77SS05hnUyhlqzsEUbW2eQhKHtDEbgTXPEF9K
         xGZg==
X-Gm-Message-State: AJIora/vraqdCrFgCaT0yQYgX7kv8RnMnapNFhVCiY+IGyS+Barhhn6X
        7renyjxi0r48NYJubsSR49gBsRL2IhUK3f2aY/oniNkcN0A5n5NMRTzAJJaKCS9j2cfiecslCZP
        rdIIGYlovH1Xlst+GPzjviHYKqIMaQeBNrJPB583loHv/4ZB8sPkSdelTEalKBNaUSUHHq/g=
X-Received: by 2002:a05:6a00:1593:b0:525:88fb:ce25 with SMTP id u19-20020a056a00159300b0052588fbce25mr13715069pfk.80.1656558310258;
        Wed, 29 Jun 2022 20:05:10 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1s8tyVBeV4QtLl+1+Jet84hDikMGXTLnhk085bwQ5dQq5V5407KFhwsEPn1glhjCRIgUVSuJQ==
X-Received: by 2002:a05:6a00:1593:b0:525:88fb:ce25 with SMTP id u19-20020a056a00159300b0052588fbce25mr13715045pfk.80.1656558309917;
        Wed, 29 Jun 2022 20:05:09 -0700 (PDT)
Received: from [10.72.12.186] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id bc12-20020a170902930c00b0015e8d4eb1d5sm12152551plb.31.2022.06.29.20.05.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jun 2022 20:05:09 -0700 (PDT)
Subject: Re: [PATCH v2 0/2] ceph: switch to 4KB block size if quota size is
 not aligned to 4MB
To:     "Yan, Zheng" <ukernel@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Venky Shankar <vshankar@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Luis Henriques <lhenriques@suse.de>,
        ceph-devel <ceph-devel@vger.kernel.org>
References: <20220627020203.173293-1-xiubli@redhat.com>
 <CAAM7YA=CcNA8HigAG4wAedUN+1dDDB8G7qXiub=+5B7nN5bjFg@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <04405a13-5d9e-232a-58fe-ef22783f4881@redhat.com>
Date:   Thu, 30 Jun 2022 11:05:02 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAAM7YA=CcNA8HigAG4wAedUN+1dDDB8G7qXiub=+5B7nN5bjFg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 6/30/22 10:39 AM, Yan, Zheng wrote:
> NACK,  this change will significantly increase mds load. Inaccuracy is
> inherent in current quota design.

Yeah, I was also thinking could we just allow the quota size to be 
aligned to 4KB if it < 4MB, or must be aligned to 4MB ?

Any idea ?

- Xiubo


> On Mon, Jun 27, 2022 at 10:06 AM <xiubli@redhat.com> wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> V2:
>> - Switched to IS_ALIGNED() macro
>> - Added CEPH_4K_BLOCK_SIZE macro
>> - Rename CEPH_BLOCK to CEPH_BLOCK_SIZE
>>
>> Xiubo Li (3):
>>    ceph: make f_bsize always equal to f_frsize
>>    ceph: switch to use CEPH_4K_BLOCK_SHIFT macro
>>    ceph: switch to 4KB block size if quota size is not aligned to 4MB
>>
>>   fs/ceph/quota.c | 32 ++++++++++++++++++++------------
>>   fs/ceph/super.c | 28 ++++++++++++++--------------
>>   fs/ceph/super.h |  5 +++--
>>   3 files changed, 37 insertions(+), 28 deletions(-)
>>
>> --
>> 2.36.0.rc1
>>

