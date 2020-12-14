Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D79D22D9D20
	for <lists+ceph-devel@lfdr.de>; Mon, 14 Dec 2020 18:01:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393353AbgLNRAu (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 14 Dec 2020 12:00:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404540AbgLNRAf (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 14 Dec 2020 12:00:35 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7325C0613D3
        for <ceph-devel@vger.kernel.org>; Mon, 14 Dec 2020 08:59:55 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id i18so17553325ioa.1
        for <ceph-devel@vger.kernel.org>; Mon, 14 Dec 2020 08:59:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=et3ubMxh5Go3brDqw4KraZ6/VmQtQ/y64vo96yrxbkI=;
        b=mkc3tWNcWdExWMi/byaK7c8Mt49dXs+0GyI8pLgxFIoxYSzdYpRg68kw/aWoVCvgfw
         qC9DZWUvhUS8JGM3sYU/6mYpoH7Wd5ROrr4d4Nkp1S2P/2dicoWNgv05HIHirdraFZr9
         bV8NpFCTBYYuFklqqLVJFVHLa5GH2katzlhB4fvTnzRI14aWoYEJsW3HaolHpLz1gKLR
         JfVD2Wc/OjkU/Xsm19kyyXaQ2bXiZqZcWBj2/9/39s5d9HIjXPhY3+hOA96cVBzU8p7U
         QJCFrSfrZPETlY0ZtoRQmw6bJc/IQii4R2aQm41WfXCh4vfyq6XlPrA60X/q/dGDOLYk
         wnWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=et3ubMxh5Go3brDqw4KraZ6/VmQtQ/y64vo96yrxbkI=;
        b=SUmqg+seoBuXbxKXn23r8VK096Yqrx7j4coQDlysJVjf/6hHKBPBsYAgQc2hvL4SFI
         LxJJuRqYuNf4RAxuytuQOtie+cE9IXO5cpi8lLMlTdN91GmkPt55qj7xQYPJrMresMeI
         ky/x1a5ieMXrbMa4AH0v8JLWsWhuFvYBmKWAiZtArb4bQGqsC+AoQbXv4uXvP4ZiEb55
         f5qPkxb+NKatFpDPU9W0E2GKlofOxAc1tlb5wZzO3FmxuFeYrAAEIGmyf/IY6U2SjBKe
         Iqn/OBSDhQfWneBL1vohssMmIo/ueJsk8dPzXQ//XivYWy/NyCY7x/UOR7P2EC4lJkqI
         EJ6A==
X-Gm-Message-State: AOAM5324TDAcsmAgC4K1ou38QlTbOrkvefY7L8+9zAAXKnUY6iEckNL4
        nezZzkXmOv5o18q3p2xlWUDK+FkW758EW820azY2JskimIA=
X-Google-Smtp-Source: ABdhPJwlpCO+vTUj8Qzs7xUpgUR6rU5dUcJGW4u49xEo19Zp70f4ce4SrF9ln4jyQbHP4l2fwXb2ws7fR0iro9hMH3Y=
X-Received: by 2002:a6b:7a09:: with SMTP id h9mr33661509iom.167.1607965195012;
 Mon, 14 Dec 2020 08:59:55 -0800 (PST)
MIME-Version: 1.0
References: <CAOi1vP_gHLrNBe-pU9G+GmE+JF8g2SY7UqgGqzeW5sXXf1jAcQ@mail.gmail.com>
 <87wnxk1iwy.fsf@suse.de>
In-Reply-To: <87wnxk1iwy.fsf@suse.de>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 14 Dec 2020 17:59:43 +0100
Message-ID: <CAOi1vP-U4Hdw=zYNFmhX_TJeuUiAAXMwvAUJLmG++F8mN+z5HQ@mail.gmail.com>
Subject: Re: wip-msgr2
To:     Luis Henriques <lhenriques@suse.de>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Dec 14, 2020 at 4:55 PM Luis Henriques <lhenriques@suse.de> wrote:
>
> Ilya Dryomov <idryomov@gmail.com> writes:
>
> > Hello,
> >
> > I've pushed wip-msgr2 and opened a dummy PR in ceph-client:
> >
> >   https://github.com/ceph/ceph-client/pull/22
> >
> > This set has been through a over a dozen krbd test suite runs with no
> > issues other than those with the test suite itself.  The diffstat is
> > rather big, so I didn't want to spam the list.  If someone wants it
> > posted, let me know.  Any comments are welcome!
>
> That's *awesome*!  Thanks for sharing, Ilya.  Obviously this will need a
> lot of time to digest but a quick attempt to do a mount using a v2 monitor
> is just showing me a bunch of:
>
> libceph: mon0 (1)192.168.155.1:40898 socket closed (con state V1_BANNER)
>
> Note that this was just me giving it a try with a dummy vstart cluster
> (octopus IIRC), so nothing that could be considered testing.  I'll try to
> find out what I'm doing wrong in the next couple of days or, worst case,
> after EOY vacations.

Hi Luis,

This is because the kernel continues to default to msgr1.  The socket
gets closed by the mon right after it sees msgr1 banner and you should
see "peer ... is using msgr V1 protocol" error in the log.

For msgr2, you need to select a connection mode using the new ms_mode
option:

  ms_mode=legacy        - msgr1 (default)
  ms_mode=crc           - crc mode, if denied fail
  ms_mode=secure        - secure mode, if denied fail
  ms_mode=prefer-crc    - crc mode, if denied agree to secure mode
  ms_mode=prefer-secure - secure mode, if denied agree to crc mode

Thanks,

                Ilya
