Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E0B55F0C67
	for <lists+ceph-devel@lfdr.de>; Fri, 30 Sep 2022 15:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231213AbiI3N1M (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 30 Sep 2022 09:27:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbiI3N1L (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 30 Sep 2022 09:27:11 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 017E718C02C
        for <ceph-devel@vger.kernel.org>; Fri, 30 Sep 2022 06:27:09 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id 13so9056670ejn.3
        for <ceph-devel@vger.kernel.org>; Fri, 30 Sep 2022 06:27:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=Bs9xupHgtakX1Ct2+WAlMYgon8p9GE5efibvPJMDD04=;
        b=jn4pJZoGqaIXBcGzYiHhduZRsIL6r0GhGiczCatfQJzuytDpeFYpIz2Um9U7+iu4L4
         TnOpZurvC9MvqYntjFhPzRrGdJlQUfpEctYd5NCq6u61txGbpywCxCGwjfKGrKbuO5rA
         3SmWUnEYOWtYeEUTVWWgwJNJ0ShDuPZK+wl7nVd1G4JZXagDgPLu+C8szoR1C7mQRTsF
         tQXv6iWti6w1KyyjkcHvGR7fMuH0G2HuAf95hqbycjXLLFfXOBlBBLgQQpbYFzLjJvRb
         EMAdBN26NrFPBtLBGKM2/CWhnPTT8vuEVMbWeo1ZdBzBuucGbN1BKA2QDmzDdI9dBd7m
         5wdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=Bs9xupHgtakX1Ct2+WAlMYgon8p9GE5efibvPJMDD04=;
        b=GINXT1r+pTFA//qXDwucJxzvwFiZmD3uopk03638maRgc4jGZDaUgEhWa4fiMofnXY
         2ILusgOVeUV9QpC3zlkwlqcR7/pzgxgjwaynrbpMpC/tvr0bwi29Gfi18E96CPqfzy8Y
         rlpsBr7e6P9TIznrG2Gc38NtWHx6/gGg9aiIjMdM318ybbifa/BVMs80TPbzpn5QBv4m
         /zt2bjqssS1Ilh/1BJoIJKgqfnJrgKZjCSpA+68++cFyImX2SLxgiA7R4ayzyGWTHAFU
         q4I6NK/8cUohujfmOxzQY7PzEmZEFj+N5xJtRa5iCWD5c/sG92K6cmPhEzDF7gLayRLD
         2Grw==
X-Gm-Message-State: ACrzQf0BzVJfn/TglLyhzVbVTll9bKB0W5eY2vWVb7KAlbh6/mP9dfh8
        87J/8iO/WyBL12oNHFgzauCR/BVFyNL1grPJFfo=
X-Google-Smtp-Source: AMsMyM7FWOf0M/k0APwzzPIipYOwfofHEuCnO/Bh3+jAYXUablD5Zt3eGCRI6rVHsWzndRgYVoPqfLJ8DgXkrsijIDY=
X-Received: by 2002:a17:907:168f:b0:788:c642:1624 with SMTP id
 hc15-20020a170907168f00b00788c6421624mr577844ejc.79.1664544428513; Fri, 30
 Sep 2022 06:27:08 -0700 (PDT)
MIME-Version: 1.0
References: <CAOi1vP9jCHppG7irvLzQgwBSzhrfgc_ak1t2wc=uTOREHVBROA@mail.gmail.com>
 <CAOi1vP8Zfix48tM1ifAgQo1xK+HGC1Sh8mh+Bc=a7Bbv1QENxA@mail.gmail.com>
 <20220928002202.GA2357386@onthe.net.au> <CAOi1vP8bk3nj=seT=1jGPzPRVti7j+D1dw_O+zqeUQp9M8T=BA@mail.gmail.com>
 <20220930000412.GB2594730@onthe.net.au>
In-Reply-To: <20220930000412.GB2594730@onthe.net.au>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Fri, 30 Sep 2022 15:26:55 +0200
Message-ID: <CAOi1vP93917SrQR=KoR=Fqac7jHfUs8SUnjwHYJiNkebYd92tQ@mail.gmail.com>
Subject: Re: rbd unmap fails with "Device or resource busy"
To:     Chris Dunlop <chris@onthe.net.au>
Cc:     Adam King <adking@redhat.com>,
        Guillaume Abrioux <gabrioux@redhat.com>,
        ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Sep 30, 2022 at 2:04 AM Chris Dunlop <chris@onthe.net.au> wrote:
>
> Hi all,
>
> On Thu, Sep 29, 2022 at 01:14:17PM +0200, Ilya Dryomov wrote:
> > On Fri, Sep 23, 2022 at 5:58 AM Chris Dunlop <chris@onthe.net.au> wrote:
> >> Why is the ceph container getting access to the entire host
> >> filesystem in the first place?
> ...
> > Right, I see your point, particularly around /rootfs location making it
> > obvious that it's not a standard shell.  I don't have a strong opinion
> > here, ultimately the fix is up to Adam and Guillaume (although I would
> > definitely prefer a set of targeted mounts over a blanket -v /:/rootfs
> > mount, whether slave or not).
>
> Perhaps this topic should be raised at a team meeting or however project
> directions are managed - i.e. whether or not to keep the blanket mount of
> the entire host filesystem or the containers should be aiming for the
> minimal filesystem access required to run. If such a discussion were to
> take place I think the general safety principals around providing minimum
> privileged access should be noted.

Indeed.  I added this as a topic for the upcoming Ceph Developer
Monthly meeting [1].

[1] https://lists.ceph.io/hyperkitty/list/dev@ceph.io/thread/VDV5YVZSLFMUAAUI2NBZMYSKCFRC5AIV/

Thanks,

                Ilya
