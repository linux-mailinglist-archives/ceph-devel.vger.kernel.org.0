Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35A135EE335
	for <lists+ceph-devel@lfdr.de>; Wed, 28 Sep 2022 19:33:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234380AbiI1RdL (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 28 Sep 2022 13:33:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234374AbiI1RdI (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 28 Sep 2022 13:33:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C411EEB63
        for <ceph-devel@vger.kernel.org>; Wed, 28 Sep 2022 10:33:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664386383;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Rs6UOXWaudUiQjCSABOoIEIbJ9ZcI+twoPbZAzEN+Z8=;
        b=GtczVa8mVcxNtVv/cNFj/sbI76Te2qvdq39jvTd67SQ2BZg6Jh5bUnovOa1aWViiEiNIzU
        0TjK8+AVtZLNuj5QtJCKFR0Z9velH4OsGh7k46HjUzeUaW/xcLh2tHc+Rdo/WQpanRvVoq
        /t1QssFwtSe8Y0WhYjzrzxkp8sc22q0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-187-v7qVaHyZOLSEPxlwqqwecA-1; Wed, 28 Sep 2022 13:32:57 -0400
X-MC-Unique: v7qVaHyZOLSEPxlwqqwecA-1
Received: by mail-wm1-f72.google.com with SMTP id v130-20020a1cac88000000b003b56eabdf04so520862wme.7
        for <ceph-devel@vger.kernel.org>; Wed, 28 Sep 2022 10:32:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=Rs6UOXWaudUiQjCSABOoIEIbJ9ZcI+twoPbZAzEN+Z8=;
        b=GVakEqT++0GbPW9bmTSyeEvk1z5+kS2ciGRpwLYodNAPBhvbmL1U3FjBAUCJD+c4xY
         QhzSF5a91juryjsvmLtkmgpAScZLprJJZRz/iloJLHMjBfXBVChPhnoNXrzN7utKusId
         el+5gFof9UFNvHHrNR5MztIvXOr3nnskoW7OrBUCwfLbIiwCqZgzkl0HkjHqHKs6XBp2
         qgvCRmYEP4ltsS+Qj1GLNVmjsEwOwdNHbMrj33Jl4+/b/nOK08CuqibEiGruxwqSG9qp
         n/Vs8Ozfqj9ussGGuqfFImo/xoHUgp64Yo6YfTSHEXA3nkdpNA4CNkIkNYxmMinOUfd2
         DfPg==
X-Gm-Message-State: ACrzQf0FqxZF3IDGAsfvaOnAQo3Eo6WG3NG6dUKPpqBCMVXQzM7lEeRe
        WgXE4+BXhAMjKEYOUB6n1FsT3D+is9BX3DIQ4MH7/vb352J3Xqv8ct2febNlFKb0A3k7xtmVs6U
        PxCENwbX/+gnelmhvkc41g4u9/K9SiD1hmwjYOA==
X-Received: by 2002:a5d:6d0b:0:b0:22a:caa8:8ef8 with SMTP id e11-20020a5d6d0b000000b0022acaa88ef8mr21864813wrq.598.1664386375435;
        Wed, 28 Sep 2022 10:32:55 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7HPhHJXu0DHuXln9ZAy3CX5pUTlui9nyy4PXLTlcl8dkddaHyeW6+uIbpVjzEQhplaKHMhSpIS7OpN7S5Rqv4=
X-Received: by 2002:a5d:6d0b:0:b0:22a:caa8:8ef8 with SMTP id
 e11-20020a5d6d0b000000b0022acaa88ef8mr21864783wrq.598.1664386374928; Wed, 28
 Sep 2022 10:32:54 -0700 (PDT)
MIME-Version: 1.0
References: <CAA4mOPr-Ejh2gmA6e3vKOpBApw9Uk6AsqC4A-OKMiwD5zUaBWw@mail.gmail.com>
 <CACw=N5OUWWVOmkNr0TdC9-Z=FzEcsyE12GKoXS-Qk4R=tT4ypw@mail.gmail.com>
In-Reply-To: <CACw=N5OUWWVOmkNr0TdC9-Z=FzEcsyE12GKoXS-Qk4R=tT4ypw@mail.gmail.com>
From:   Mike Perez <miperez@redhat.com>
Date:   Wed, 28 Sep 2022 10:32:28 -0700
Message-ID: <CAFFUGJdPuYdnt1=SCCS73gQsZqz6a8Ma3pQEWHC3eCDCXs73Hg@mail.gmail.com>
Subject: Re: Ceph Tech Talk : Making Teuthology a Better Detective
To:     Vallari Agrawal <val.agl002@gmail.com>
Cc:     Gaurav Sitlani <sitlanigaurav7@gmail.com>,
        Ceph Development List <ceph-devel@vger.kernel.org>,
        ceph-users@lists.ceph.com, dev <dev@ceph.io>,
        Josh Durgin <jdurgin@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.0 required=5.0 tests=BAYES_20,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,LOTS_OF_MONEY,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Thank you, Vallari, for presenting our latest tech talk, and Gaurav for hosting!

Here is the recording in case you missed it.

https://www.youtube.com/watch?v=hPt0WbYtDxA

On Thu, Aug 25, 2022 at 7:02 AM Vallari Agrawal <val.agl002@gmail.com> wrote:
>
> Slides for the presentation:
> https://docs.google.com/presentation/d/1jfVQW6PVQzRl_thqUWU_gzb0suhcF-rkHdfx8SqTB6g/edit?usp=sharing
>
> On Wed, 24 Aug 2022 at 18:42, Gaurav Sitlani <sitlanigaurav7@gmail.com> wrote:
>>
>> Hi everyone,
>>
>> It's a pleasure to announce our next Ceph Tech Talk on Thursday,August 25 at 14:00 UTC by Vallari Agrawal, she's an Intern working on Ceph Outreachy project :
>>
>> Her github link : https://github.com/VallariAg
>> Please join us for the same to learn more about her work.
>>
>> To join the meeting on a computer or mobile phone:
>>
>> https://bluejeans.com/908675367/browser
>>
>> To join via Phone:
>> 1) Dial:
>>           +1 408 740 7256
>>           +1 888 240 2560(US Toll Free)
>>           +1 408 317 9253(Alternate Number)
>>           (see all numbers - http://bluejeans.com/numbers)
>> 2) Enter Conference ID: 908675367
>>
>>
>> Kind regards,
>> Gaurav Sitlani



-- 
Mike Perez

