Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D02EE50DC75
	for <lists+ceph-devel@lfdr.de>; Mon, 25 Apr 2022 11:23:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235407AbiDYJ03 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 25 Apr 2022 05:26:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235853AbiDYJ00 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 25 Apr 2022 05:26:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 86788245B2
        for <ceph-devel@vger.kernel.org>; Mon, 25 Apr 2022 02:23:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650878599;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hxGxVEyfQ7cLJR7NkCoem2oGNDmdXaFLkUtzjB9Kbv0=;
        b=h0AVZhcekN4ieAQ5bYoZ3MqXXU4Q2ZQt0nJEGqqRpn6e7qvMUMfvJG6mzKzCLJCP8PT1wl
        IdiYiV+uj9nUtnp8WHRnzTeWHzIyNgOU6mG1TavL/iUL6dc20NO9eZZio4RdIPzIUtAKPQ
        AWPNuBm3WrPfbEnyOHbj3YsQ1rl/Vm4=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-121-wEjFj51DPuC9u-W6BP-6KA-1; Mon, 25 Apr 2022 05:23:18 -0400
X-MC-Unique: wEjFj51DPuC9u-W6BP-6KA-1
Received: by mail-pg1-f200.google.com with SMTP id z132-20020a63338a000000b003844e317066so8973714pgz.19
        for <ceph-devel@vger.kernel.org>; Mon, 25 Apr 2022 02:23:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=hxGxVEyfQ7cLJR7NkCoem2oGNDmdXaFLkUtzjB9Kbv0=;
        b=u8y9trAiPiD/ZDMc2ximko054spb8EvRIxzaeL8zu9B0qBPymuq6ZgiZqqKeV2o1H7
         Kkum5jnKmFiig3a7AVPULLPDXRciKzPzcrc+vmQIgEUz1l+YNqt/J4lSk4osuDVC20Dd
         89W3x7dfrWhqMqEdTzMDnbVPw3SBQvi2YY+mSfF9l8NftugUFfEBXI92f9TyPFxgPo9X
         XP3Hon4sTSiviOK6JSKHHhi/8JGnpE+YPwg6i/BUXO2lq4emCaIWa5MdDxXyKy6EX891
         Qv4cXo3EPLnIWXHbxCyTm8nC4czchWabxHWyrmno1iBeKuPKl+vBd1KmI2QN5jb9Gplm
         j+qQ==
X-Gm-Message-State: AOAM532OKYSP6fwUYn7a+q+QNbjgqJJE1lbqkw9sADYHUO5hWLlc6ui+
        vAgArXOHm9Fhhfqgm4bSxwzqMaXSDS6tHknvKb8XdMzNuborO3LG66C4CRwTjWFMK2nOIczBV17
        fE/HiDZp6k4Axg96KiZdBXPVtVztlhzp4bigpjsFJvEGPEULDlrJ80Kew7KMkvfzLFeS2v1U=
X-Received: by 2002:a17:902:8306:b0:158:ea27:307d with SMTP id bd6-20020a170902830600b00158ea27307dmr16824349plb.164.1650878597237;
        Mon, 25 Apr 2022 02:23:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyhqmmp28FQvP8kndb3I7cUX+iBjlpXexJ/+tAv/2REM2kYvxnQE1HwJyTZP7Z1j9jOF78lnA==
X-Received: by 2002:a17:902:8306:b0:158:ea27:307d with SMTP id bd6-20020a170902830600b00158ea27307dmr16824321plb.164.1650878596864;
        Mon, 25 Apr 2022 02:23:16 -0700 (PDT)
Received: from [10.72.12.77] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y126-20020a62ce84000000b0050d223013b6sm7248730pfg.11.2022.04.25.02.23.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Apr 2022 02:23:16 -0700 (PDT)
Subject: Re: [PATCH v2] ceph: fix possible NULL pointer dereference for
 req->r_session
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Aaron Tomlin <atomlin@redhat.com>,
        Jeff Layton <jlayton@kernel.org>,
        Venky Shankar <vshankar@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
References: <20220418014440.573533-1-xiubli@redhat.com>
 <20220418104318.4fb3jpdgnhje4b5d@ava.usersys.com>
 <53d24ea4-554b-2df3-e4ee-6761f6ae5c8e@redhat.com>
 <20220418144554.i7m6omhtulb2nq22@ava.usersys.com>
 <7a636228-263a-248c-cb41-a1872acd28f1@redhat.com>
 <CAOi1vP-0jYr61B2BNcus8NwUOUByfr6t=FJF99wVEXe-H=+hCg@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <f1d27483-34a8-3409-23ea-621cffb26872@redhat.com>
Date:   Mon, 25 Apr 2022 17:23:10 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAOi1vP-0jYr61B2BNcus8NwUOUByfr6t=FJF99wVEXe-H=+hCg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 4/25/22 5:03 PM, Ilya Dryomov wrote:
> On Tue, Apr 19, 2022 at 3:01 AM Xiubo Li <xiubli@redhat.com> wrote:
>>
>> On 4/18/22 10:45 PM, Aaron Tomlin wrote:
>>> On Mon 2022-04-18 18:52 +0800, Xiubo Li wrote:
>>>> Hi Aaron,
>>> Hi Xiubo,
>>>
>>>> Thanks very much for you testing.
>>> No problem!
>>>
>>>> BTW, did you test this by using Livepatch or something else ?
>>> I mostly followed your suggestion here [1] by modifying/or patching the
>>> kernel to increase the race window so that unsafe_request_wait() may more
>>> reliably see a newly registered request with an unprepared session pointer
>>> i.e. 'req->r_session == NULL'.
>>>
>>> Indeed, with this patch we simply skip such a request while traversing the
>>> Ceph inode's unsafe directory list in the context of unsafe_request_wait().
>> Okay, cool.
>>
>> Thanks again for your help Aaron :-)
>>
>> -- Xiubo
>>
>>
>>> [1]: https://tracker.ceph.com/issues/55329
>>>
>>> Kind regards,
>>>
> I went ahead and marked this for stable (it's already queued for -rc5).

Sure, thanks Ilya.

-- Xiubo


> Thanks,
>
>                  Ilya
>

