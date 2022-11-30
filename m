Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69E3163CF71
	for <lists+ceph-devel@lfdr.de>; Wed, 30 Nov 2022 08:00:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233235AbiK3HAB (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 30 Nov 2022 02:00:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbiK3HAA (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 30 Nov 2022 02:00:00 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A715D45EDA
        for <ceph-devel@vger.kernel.org>; Tue, 29 Nov 2022 22:59:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669791542;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=n+lvfxRF/QBwjY5l736R42OTu9NqWHaCKr92yPIrz+k=;
        b=KZc4OHVrKD5Xg2mTNDgnR0R6q89IPYBYqKNTQPi2iy2MMHuoyluVV6OUaabxixg1NFH3rS
        YGpEXm3i9iCuUu8SS/KvtcwwYySdld6BC6/NiSaYXs9IMPn6DKmwG5qSM758lIX+lYvhS6
        PSNmSA5ypY6kSTLNAFXNT7yGByPWt8I=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-530-K9JiE_EwPHmflwVHrKia1w-1; Wed, 30 Nov 2022 01:59:01 -0500
X-MC-Unique: K9JiE_EwPHmflwVHrKia1w-1
Received: by mail-io1-f69.google.com with SMTP id x5-20020a6bda05000000b006db3112c1deso10424736iob.0
        for <ceph-devel@vger.kernel.org>; Tue, 29 Nov 2022 22:59:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=n+lvfxRF/QBwjY5l736R42OTu9NqWHaCKr92yPIrz+k=;
        b=lf3BWbIqPYn7WIZBwNiXzRlWWgOgO+Df2DJE0o0KtONsUsmkmBd1KYLAppGgrPQVvD
         ln636LjUliDoSbUFKqg4tHewAkhLz+U4vPdNtd4enkLRdWKdrzcuHK42m3iXSRMB2PkD
         PEvVYe1JMoScJwkuVfR4V1R9gOFhHJIhIM8NbMk8pmH7bPOv6a4QPskRsK1j4W5x7rxF
         pvasOLICCFKORPfFdXpCP2N5lIPjEKnmQKGMdxTW4RqdSWr/WFsCnpqkL9URy/s9dGV0
         W5tpulxKtYelLZfFw1kI0R1F3ao30p5hgCfqTEyX/QECuLM6j3fHKkN5k8VZ2eE8hFMp
         vk0w==
X-Gm-Message-State: ANoB5pllWg0aQkV+Pk85gQBvIxR14HVox9HWVUdUxIleDmfIkYeapuJF
        TjMPsDyrgDR75M3BCwD5gSWODRb4y7ADG9XVoaj8jVG25kMBZgjh1Yvg6FAglq4HWvjUm8MVM9E
        4OT8/ygczuHulk6+SvBGAZmEOmHA5s4UqYObpOw==
X-Received: by 2002:a05:6602:2105:b0:6d8:de69:14b4 with SMTP id x5-20020a056602210500b006d8de6914b4mr28838147iox.140.1669791540293;
        Tue, 29 Nov 2022 22:59:00 -0800 (PST)
X-Google-Smtp-Source: AA0mqf593pfofgA5+r571Qta9MdwlFrrhy8GN3B+TJ4RukBkv0xNPMKzN6MuYTqRDZJ+5lpztaEqye+Vn2Az4IUiTGU=
X-Received: by 2002:a05:6602:2105:b0:6d8:de69:14b4 with SMTP id
 x5-20020a056602210500b006d8de6914b4mr28838140iox.140.1669791539905; Tue, 29
 Nov 2022 22:58:59 -0800 (PST)
MIME-Version: 1.0
References: <CAMym5wv3pxf09OMOFn8ZcCJL=gi0dstaeTTLCngghVvqb7-zPw@mail.gmail.com>
In-Reply-To: <CAMym5wv3pxf09OMOFn8ZcCJL=gi0dstaeTTLCngghVvqb7-zPw@mail.gmail.com>
From:   Gregory Farnum <gfarnum@redhat.com>
Date:   Tue, 29 Nov 2022 22:58:52 -0800
Message-ID: <CAJ4mKGZ-ACGJXW+sQRD+1uphco0a-EY3eHN3EJgis=qswMNc3Q@mail.gmail.com>
Subject: Re: Does the official QA process use HDD for OSD?
To:     Satoru Takeuchi <satoru.takeuchi@gmail.com>, dev <dev@ceph.io>,
        Yuri Weinstein <yweinste@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

[ Moving to Ceph dev list instead of kernel ceph-devel. ]

On Mon, Nov 28, 2022 at 6:51 PM Satoru Takeuchi
<satoru.takeuchi@gmail.com> wrote:
>
> Hi,
>
> I shared my knowledge about the bugs which my team encountered and two
> proposals to improve the official QA process in Ceph Virtual.
>
> https://www.youtube.com/watch?v=ENvDbgX4n38
> https://speakerdeck.com/sat/revealing-bluestore-corruption-bugs-in-containerized-ceph-clusters
>
> One of my proposals depends on the assumption that the official QA
> doesn't use HDD.
> It's because my team revealed many bugs in OSD creation/restart only
> in HDD-based clusters.
> Could you tell me whether my assumption is correct or not?

It's possible to run the test on hard drives, and developers still
schedule them there sometimes, but doing so is quite expensive at this
point (just because it takes a while to set up hard-drive based test
nodes and takes longer to get a suite run completed against your
branch) and so most of the lab is SSD/NVME based.

I'm not sure if we run any HDD-based tests prior to releases or on a
regular basis; I think Yuri can answer that question.
-Greg

>
> Thanks,
> Satoru
>

