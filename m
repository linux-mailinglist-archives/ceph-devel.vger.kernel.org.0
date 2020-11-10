Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 785B42ADB50
	for <lists+ceph-devel@lfdr.de>; Tue, 10 Nov 2020 17:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731297AbgKJQKM (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 10 Nov 2020 11:10:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731255AbgKJQKM (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 10 Nov 2020 11:10:12 -0500
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01C58C0613CF
        for <ceph-devel@vger.kernel.org>; Tue, 10 Nov 2020 08:10:12 -0800 (PST)
Received: by mail-il1-x141.google.com with SMTP id y17so12660065ilg.4
        for <ceph-devel@vger.kernel.org>; Tue, 10 Nov 2020 08:10:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YdO/OsZ7g0niNKpOdu/HrSgtmCp33Ty9xFql67a/vZ8=;
        b=npH1gKpADpV3WI8x5DhJ28PcWkWD2ESdFyb8KI7/GHZb1vhGemAMqJA1mnFia6TbRI
         XQbtA+RXKsmME4Y9QzmAalfMC4dHWMrxS7N5ks8gfEbS4qKk97QIq7LOqlPoFEmnacf7
         W+PDUITdZGmer8NJdvNjl4M0MY6qbtdQ9FQv0G7E8zpKjHe9qBnzav0j+r1NzStw6ZhT
         sLONyWIxkH+yc2xSxVs5J0fJMKJyb1KlaotlSBqJiFW7v+dzvmJ6+FMik8abDgvjBrsM
         Q6jrRCJQEGsATP/8Gqlaq9iS+x8f8fDeynklCEQiUM+3jEoTxMdntRU3+C1JK2orT07+
         qXPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YdO/OsZ7g0niNKpOdu/HrSgtmCp33Ty9xFql67a/vZ8=;
        b=jfYz2ChYNl/6oMrh2pL92zl50HpAJwRD490gR9Vm+uEUc0KPi3a+owdg7WIzmQptn2
         OKElPCntz2Lkce0EJ0E5bnsGH3gw82seJG5hL6e//uhSSQXpeeNQDFtBRpyZOx/2u44G
         wzTf93ia955ndvqQmJQHFfF7nL9ZbFIzMaWT0lA6OzxDMpMG5o2feUJ4wl1GKc0KHqYf
         mzVLfem+5Fq7ze8+O8E9nFzIREJUurztXMUGvyW5vpbrfboecFc13owDKj4aEhHPlans
         z4Fr1vrgSV5kaQqGvrxKTFUs05KZL5fuSiHMBcA/N0BQ2t0Mrf49sBDxm1QwMnXcAmvY
         5p1Q==
X-Gm-Message-State: AOAM531EW6bCV1nYwsCB45pmUCFYRHycKUJ7XAD2OZlgtXPj7UJvZvQ9
        cfjSkRkxLSQv7QXiUzHRCw4a8l8Ua81SQnk0he0=
X-Google-Smtp-Source: ABdhPJwUYkx27p8lSXQAHHHzN9HQxxKA4SSKZbNk2SBzQafv/zVDj+s2siDCntsP7i92SSmVpGSRukStnO6+zUfpTpE=
X-Received: by 2002:a92:ba56:: with SMTP id o83mr15758682ili.19.1605024611458;
 Tue, 10 Nov 2020 08:10:11 -0800 (PST)
MIME-Version: 1.0
References: <20201110135201.GA90549@nstpc> <d8de425bc32a5d26c48494ef71fa93c2c60a9a2c.camel@kernel.org>
In-Reply-To: <d8de425bc32a5d26c48494ef71fa93c2c60a9a2c.camel@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 10 Nov 2020 17:10:11 +0100
Message-ID: <CAOi1vP9h96K+HFdWUun69pZjwXC9bkbYAELUED1ixaXiA2LzTw@mail.gmail.com>
Subject: Re: [PATCH] libceph: remove unused defined macro for port
To:     Jeff Layton <jlayton@kernel.org>
Cc:     "Liu, Changcheng" <changcheng.liu@intel.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Nov 10, 2020 at 3:00 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Tue, 2020-11-10 at 21:52 +0800, changcheng.liu@intel.com wrote:
> > 1. monitor's default port is defined by CEPH_MON_PORT
> > 2. CEPH_PORT_START & CEPH_PORT_LAST are not needed.
> >
> > Signed-off-by: Changcheng Liu <changcheng.liu@aliyun.com>
> >
> > diff --git a/include/linux/ceph/msgr.h b/include/linux/ceph/msgr.h
> > index 1c1887206ffa..feff5a2dc33e 100644
> > --- a/include/linux/ceph/msgr.h
> > +++ b/include/linux/ceph/msgr.h
> > @@ -7,15 +7,6 @@
> >
> >
> >  #define CEPH_MON_PORT    6789  /* default monitor port */
> >
> >
> > -/*
> > - * client-side processes will try to bind to ports in this
> > - * range, simply for the benefit of tools like nmap or wireshark
> > - * that would like to identify the protocol.
> > - */
> > -#define CEPH_PORT_FIRST  6789
> > -#define CEPH_PORT_START  6800  /* non-monitors start here */
> > -#define CEPH_PORT_LAST   6900
> > -
> >  /*
> >   * tcp connection banner.  include a protocol version. and adjust
> >   * whenever the wire protocol changes.  try to keep this string length
>
> Thanks! Merged into testing branch.

Jeff, the From address doesn't match the SOB address here.  A few
weeks ago I asked Changcheng to resend because of this and it looks
like he sent two copies of the same patch today.  The other one seems
to be in order -- please drop this one.

Thanks,

                Ilya
