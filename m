Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF414C1E6F
	for <lists+ceph-devel@lfdr.de>; Wed, 23 Feb 2022 23:28:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238991AbiBWW2k (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 23 Feb 2022 17:28:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231311AbiBWW2k (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 23 Feb 2022 17:28:40 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2D1C403D9
        for <ceph-devel@vger.kernel.org>; Wed, 23 Feb 2022 14:28:10 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id i11so331378eda.9
        for <ceph-devel@vger.kernel.org>; Wed, 23 Feb 2022 14:28:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=croit.io; s=gsuite-croitio;
        h=message-id:date:mime-version:user-agent:subject:to:references:from
         :in-reply-to:content-transfer-encoding;
        bh=E86OWZ18+jTBjJWcuTOVhIn29I75keJaSNEMOkS63ZU=;
        b=PWM/HEy55WLZ609RULthwtkjetJGbBawltXKvb8iPDo5uDXaQ8f0Jb/wnENs9Nt2I0
         yJmaGft8ORLSdwU65xapE5oZqc/UbZN0aLnC034S2kxGAlzr4eAnDsShibgdmu0kZrJA
         WkAYLf08yqDNYiO5UcxDUHkraIll0NqI2FXTpevCLmp35Co8OpzOcrd/GTrCrgCOqI4j
         2t6h0kB0tq2d68ihFIScchE7S84EGDf3rEdFfYGD2owD4b09gqjl54kCJIZ/7SOYmmtd
         WMiLDKLhM4OKQw7fEHOutQ2V3otve356yQvKKDMLezhYIuSBECGmUktVCvGUFC0PzFlt
         OS6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:references:from:in-reply-to:content-transfer-encoding;
        bh=E86OWZ18+jTBjJWcuTOVhIn29I75keJaSNEMOkS63ZU=;
        b=F8Cc02dLn7U9yXXz0AETnR34KuOW4SHd62RmPvIQt+uem67VZT9+TJTqEiblUYtMQc
         e0j0KotsYPDv320pZ+xODPk0teef2MqnzPCP5HDpC0uSv9SiTz6FlifXkAtmlOb2LZIZ
         IVXIBil7OWxM07pb1dWYWYvAFkd2hFUC8HAUKJtUsMFB3upr7/e5DUBZdfpbJlxEM6Ix
         V6yaspZRkIj3MHYkfvcHbDnQzSt3AoQaCOpytPW68e2N5W9/4tMemDOFFyFxC6IKchXe
         yJ1KGoxunNGR27DfrFDqHPQnHxEnhZHAxHpUT/D8svcdJP+nWdemUlENrl5Gls7aeDTR
         YWRw==
X-Gm-Message-State: AOAM533ZGGDzKxR6UpCdWZ0Sq/wCeHcneu3x2YefxCqBrpubjjr1ZTKq
        wzKLHppy24NRkTmWFM8lOWUpyg==
X-Google-Smtp-Source: ABdhPJy9WBkZpz2tUdOdZfrf6FVDmoaRw6QDuYMdJyO+xMtaB7AMW3M7yjG3IJ834OPuM1BM8+ESDw==
X-Received: by 2002:a50:fc81:0:b0:408:4c2d:bf69 with SMTP id f1-20020a50fc81000000b004084c2dbf69mr1455502edq.229.1645655289320;
        Wed, 23 Feb 2022 14:28:09 -0800 (PST)
Received: from [192.168.8.154] ([178.212.250.5])
        by smtp.gmail.com with ESMTPSA id hp7sm381363ejc.144.2022.02.23.14.28.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Feb 2022 14:28:08 -0800 (PST)
Message-ID: <c2da1dfb-0d95-caa0-7652-f50d67898bde@croit.io>
Date:   Thu, 24 Feb 2022 01:28:07 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: Benching ceph for high speed RBD
To:     Mark Nelson <mnelson@redhat.com>,
        Bartosz Rabiega <bartosz.rabiega@ovhcloud.com>,
        dev <dev@ceph.io>, ceph-devel <ceph-devel@vger.kernel.org>
References: <d55c21fb8ba54ee1b8b1e60ccc0bb21b@ovhcloud.com>
 <47a841af-6bcd-8e8d-d6dd-2071f435bd6f@redhat.com>
From:   Igor Fedotov <igor.fedotov@croit.io>
In-Reply-To: <47a841af-6bcd-8e8d-d6dd-2071f435bd6f@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Mark,

Just FYI. The performance regression in Pacific release prior to 16.2.6  
could be also caused by a redundant deferred write usage. Which was 
fixed by: https://tracker.ceph.com/issues/52244

Thanks,
Igor

On 2/23/2022 5:26 PM, Mark Nelson wrote:
>
> 4k randwrite    Sweep 0 IOPS    Sweep 1 IOPS    Sweep 2 IOPS Notes
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 14.0.0        496381        491794        451793        Worst
> 14.2.0        638907        620820        596170        Big improvement
> 14.2.10        624802        565738        561014
> 14.2.16        628949        564055        523766
> 14.2.17        616004        550045        507945
> 14.2.22        711234        654464        614117        Huge start, 
> but degrades
>
> 15.0.0        636659        620931        583773
> 15.2.15        580792        574461        569541        No longer 
> degrades
> 15.2.15b    584496        577238        572176        Same
>
> 16.0.0        551112        550874        549273        Worse than 
> octopus? (Doesn't match prior Intel tests)
> 16.2.0        518326        515684        523475 Regression, doesn't 
> degrade
> 16.2.4        516891        519046        525918
> 16.2.6        585061        595001        595702        Big win, 
> doesn't degrade
> 16.2.7        597822        605107        603958        Same
> 16.2.7b        586469        600668        599763        Same
>
>
> FWIW, we've also been running single OSD performance bisections:
> https://gist.github.com/markhpc/fda29821d4fd079707ec366322662819
>
> I believe at least one of the regressions may be related to
> https://github.com/ceph/ceph/pull/29674
>
> There are other things going on in other tests (large sequential 
> writes!) that are still being diagnosed.
>
> Mark
>
>
-- 
Igor Fedotov
Ceph Lead Developer

Looking for help with your Ceph cluster? Contact us at https://croit.io

croit GmbH, Freseniusstr. 31h, 81247 Munich
CEO: Martin Verges - VAT-ID: DE310638492
Com. register: Amtsgericht Munich HRB 231263
Web: https://croit.io | YouTube: https://goo.gl/PGE1Bx

