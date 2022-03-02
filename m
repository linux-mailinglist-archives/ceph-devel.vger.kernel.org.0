Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 368EF4CAB17
	for <lists+ceph-devel@lfdr.de>; Wed,  2 Mar 2022 18:03:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235475AbiCBREU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 2 Mar 2022 12:04:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234237AbiCBRES (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 2 Mar 2022 12:04:18 -0500
Received: from mail-vs1-xe35.google.com (mail-vs1-xe35.google.com [IPv6:2607:f8b0:4864:20::e35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39B67BC32
        for <ceph-devel@vger.kernel.org>; Wed,  2 Mar 2022 09:03:33 -0800 (PST)
Received: by mail-vs1-xe35.google.com with SMTP id d11so2590231vsm.5
        for <ceph-devel@vger.kernel.org>; Wed, 02 Mar 2022 09:03:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sR0eaKexI3R+MHsPJeepdk/XWc9rtxRxfYNss+JT7LQ=;
        b=EbLOpUN0b0sft4WB6TpvYTunjvbgYnHyubvY78kcNymVyBqdOpKFXR6pPzixMQJ7ua
         GBty+g9FwWJ3VOmNf3c6lR00hBN0dTYQEr9oNUdtVFt69LR/LMUcUpVQxciod/+GyEIY
         cyWfWLn6haDJDXb04tQm2CzaUczQc1GIrfPrt/kpVonV9R6SfuxMgsHpml9BW9xSBD+v
         ZJCH5uozPZap6bKodgKeg1JYItN+LNESvwBXqwPNGo69YK5hysmceZ+pK/SGzU2omwC5
         p9XojueDcYI9kBpRO7piS1VppJTnRy8e77mn8LHsrFKJmBqPTwNOxJ7ISadqazAXygQ8
         gDLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sR0eaKexI3R+MHsPJeepdk/XWc9rtxRxfYNss+JT7LQ=;
        b=4WCU2kYrtPh52trhX84KRhY2ckRSYtzAjXrSWvh/TgqjQ5duKcUt7XheLYJ7XUSlue
         /DeDfC1euWV5hU2jUytuYJaczHCyyoRBX1OE3ge3esvhkEkdJMXWnTAx6s7X+7T4BNME
         3arSslifxpZWdMBF0ehC4HKEDg2/6zHbu94Xph6/efCJGMwXN0eQIP92m1a/on4y19s4
         RPZg+jN+thPzOCVBGSkBr/6LjAW4tA0ruZuy03CNTKseozSGY7Q2yYA3MG7FWpmKikrA
         gYwEeehMWe0rOtATgM4N5Maj+DpkMNjRMtZvIiVEi9nbppy+mlEwPPIp8H+HFfIdIevs
         Mk1w==
X-Gm-Message-State: AOAM532O/hg+486NDXVtcgkaUL/2DfbuL1lPGcr3baIknfXaesls6wz1
        5VDsEX6Fq1ckgyDmpQQz2ZD9TqodFMjOD9RKaV0=
X-Google-Smtp-Source: ABdhPJxd//cuV7w7U7NHd1hCM+TkN/p/K/Eancy4vLxLr2dhDmvgRM7p5fxihZwoETv/ABaxKIq2+ctz/la87TSWr9Y=
X-Received: by 2002:a05:6102:3750:b0:30f:8289:939a with SMTP id
 u16-20020a056102375000b0030f8289939amr13921404vst.14.1646240612290; Wed, 02
 Mar 2022 09:03:32 -0800 (PST)
MIME-Version: 1.0
References: <20220302153744.43541-1-jlayton@kernel.org> <b10682fe-54a9-5103-4921-66f8c0f22382@ieee.org>
 <a2fef081f2fd7b65990d56b99292880e4ac0b842.camel@kernel.org>
In-Reply-To: <a2fef081f2fd7b65990d56b99292880e4ac0b842.camel@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 2 Mar 2022 18:03:56 +0100
Message-ID: <CAOi1vP_dbPNBwsLDe3uFHL0j1WDKdtEQxg9yDDBPwYM-CuOKog@mail.gmail.com>
Subject: Re: [PATCH] libceph: fix last_piece calculation in ceph_msg_data_pages_advance
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Alex Elder <elder@ieee.org>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        Xiubo Li <xiubli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Mar 2, 2022 at 5:15 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Wed, 2022-03-02 at 09:41 -0600, Alex Elder wrote:
> > On 3/2/22 9:37 AM, Jeff Layton wrote:
> > > It's possible we'll have less than a page's worth of residual data, that
> > > is stradding the last two pages in the array. That will make it
> > > incorrectly set the last_piece boolean when it shouldn't.
> > >
> > > Account for a non-zero cursor->page_offset when advancing.
> >
> > It's been quite a while I looked at this code, but isn't
> > cursor->resid supposed to be the number of bytes remaining,
> > irrespective of the offset?
> >
>
> Correct. The "residual" bytes in the cursor, AFAICT.
>
> > Have you found this to cause a failure?
> >
>
> Not with the existing code in libceph, as it only ever seems to advance
> to the end of the page. I'm working on some patches to allow for sparse
> reads though, and with those in place I need to sometimes advance to
> arbitrary positions in the array, and this reliably causes a BUG_ON() to
> trip.

Hi Jeff,

Which BUG_ON?  Can you explain what "advance to arbitrary positions in
the array" means?

I think you may be misusing ceph_msg_data_pages_advance() because
cursor->page_offset _has_ to be zero at that point: we have just
determined that we are done with the current page and incremented
cursor->page_index (i.e. moved to the next page).  The way we
determine whether we are done with the current page is by testing
cursor->page_offset == 0, so either your change is a no-op or
something else is broken.

Thanks,

                Ilya
