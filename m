Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 842834BC4E3
	for <lists+ceph-devel@lfdr.de>; Sat, 19 Feb 2022 03:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240749AbiBSCgI (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 18 Feb 2022 21:36:08 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232054AbiBSCgH (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 18 Feb 2022 21:36:07 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DEF5F15DB1C
        for <ceph-devel@vger.kernel.org>; Fri, 18 Feb 2022 18:35:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645238149;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EhpXPaddjX4A6cKtV7J7CjEIcSVDghJ7J4Tc0EBPcjo=;
        b=FlL4yPVAij37PlcU32u4RZIqxMzi1otMqI5CB3vBPTAOGm8hV7ZRpnL7ts7tjrvCzE89eZ
        S24xDY5oA0lJso/0omYcZGqXUSaDuYetT3LEZdlMBbr+uz6AOwB3xlchReKCfjxG+AiHuJ
        EHqni6CwsxFbqLSDSjeILiXTt1GE5Ms=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-647-Fsim-bfZNR-GLBDGg2w5FA-1; Fri, 18 Feb 2022 21:35:47 -0500
X-MC-Unique: Fsim-bfZNR-GLBDGg2w5FA-1
Received: by mail-pj1-f70.google.com with SMTP id br11-20020a17090b0f0b00b001b90caa826fso6036893pjb.0
        for <ceph-devel@vger.kernel.org>; Fri, 18 Feb 2022 18:35:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=EhpXPaddjX4A6cKtV7J7CjEIcSVDghJ7J4Tc0EBPcjo=;
        b=XFgLh0HU1pbIQUR268nyJoBR3P9EIe/VyBWuthcJbsZVzrGbJR99HsOCZiYjkuRP6U
         hWERSJxk4+Tlj0Qh8AVQkrXu0JBVFAY92WSYoFc2l411zt13q+ArPQ6WO+9b1IvC3oSs
         DpeTK4IXdR99HP+y8uUAocNGOpEtYweVOZpFybBwkm7yWOVFE9vvQsF9/EN7evEsY+ZL
         V9QzSvUU6VVm0dViGvvZovCgWyqkK89JTDWREm+3qNQRfcYB+J9OVMG9ajTBAoNgJLvs
         zh0pTIlrJtQC+VcTp3z441tlLQXAqs119UFWdx8HsIKSUs2Zh/llidPoEo2Hidfua0gX
         WdtA==
X-Gm-Message-State: AOAM5306nn/dZdgIAmYE5c4lHOfSBCMwpW5eOYb25KssjMAPeXUolJV0
        bsSd5I6sCRvZTRRF/l6h4Diq3c0d+5gaGq/6sH7KGkxkThtsjA0EvNl1aiB9QoHr4y5IVx/EZko
        AKwz2yyhhnS/MsWrFhBtynWQ/vOggi2chark9vPmmrscw0rpE9zUX4hUfe5lnjRQWSp4nTsQ=
X-Received: by 2002:a17:903:244f:b0:14e:d886:3b5c with SMTP id l15-20020a170903244f00b0014ed8863b5cmr9972137pls.146.1645238146171;
        Fri, 18 Feb 2022 18:35:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw4tRcoPidYpZ9PsI3ap/fov8RIDCgt3Q0WBwWj3XbR11+sp1L/y/uiQvtEXMsSvun2+CX7Rw==
X-Received: by 2002:a17:903:244f:b0:14e:d886:3b5c with SMTP id l15-20020a170903244f00b0014ed8863b5cmr9972116pls.146.1645238145849;
        Fri, 18 Feb 2022 18:35:45 -0800 (PST)
Received: from [10.72.12.153] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s5sm4257152pfd.66.2022.02.18.18.35.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Feb 2022 18:35:45 -0800 (PST)
Subject: Re: [PATCH v2] ceph: do not update snapshot context when there is no
 new snapshot
To:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>
Cc:     jlayton@kernel.org, idryomov@gmail.com, vshankar@redhat.com,
        ukernel@gmail.com, ceph-devel@vger.kernel.org
References: <20220218024722.7952-1-xiubli@redhat.com>
 <877d9si0b1.fsf@brahms.olymp>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <2d694ae4-5e06-7729-3dd5-063b5ab76ffd@redhat.com>
Date:   Sat, 19 Feb 2022 10:35:38 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <877d9si0b1.fsf@brahms.olymp>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 2/19/22 12:53 AM, Luís Henriques wrote:
> Hi!
>
> I'm seeing the BUG below when running a simple fsstress on an encrypted
> directory.  Reverting this commit seems to make it go away, but I'm not
> yet 100% sure this is the culprit (I just wanted to report it before going
> offline for the weekend.)

BTW, were you using the 'testing' branch ? It seems Jeff has not 
included the fscrypt patches yet in it.

- Xiubo

>
> I stared at this code for a bit, but no light so far.
>
> Cheers,

