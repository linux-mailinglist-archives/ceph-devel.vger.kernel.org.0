Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1FB22ADBB2
	for <lists+ceph-devel@lfdr.de>; Tue, 10 Nov 2020 17:23:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730312AbgKJQXo (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 10 Nov 2020 11:23:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:52870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729992AbgKJQXo (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 10 Nov 2020 11:23:44 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDB9020829;
        Tue, 10 Nov 2020 16:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605025423;
        bh=qzkIzPKuHgExU7xb3UkY1bcV00Q2XwefE6YY+sTf5Cw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=xtTB0Zz3441t9dkgOkK09wfgqRk60JUWhFjCWZJ1dKMyhC9fgJ5/StGPgUJIzMO++
         LvazWbwaVKjc5VcD/J4IjMX5KfLpL27EwjLCI0jZhLtxsD5cpTdiuCz2VLyn9H5rVU
         DYfeeCh0nRsP0s4U+3X1+2ePfqwpOKa4c9Zy8Gvs=
Message-ID: <d1448816b4acd559bce60dbc3cbec5378d796910.camel@kernel.org>
Subject: Re: [PATCH] libceph: remove unused defined macro for port
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     "Liu, Changcheng" <changcheng.liu@intel.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Date:   Tue, 10 Nov 2020 11:23:41 -0500
In-Reply-To: <CAOi1vP9h96K+HFdWUun69pZjwXC9bkbYAELUED1ixaXiA2LzTw@mail.gmail.com>
References: <20201110135201.GA90549@nstpc>
         <d8de425bc32a5d26c48494ef71fa93c2c60a9a2c.camel@kernel.org>
         <CAOi1vP9h96K+HFdWUun69pZjwXC9bkbYAELUED1ixaXiA2LzTw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1 (3.38.1-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2020-11-10 at 17:10 +0100, Ilya Dryomov wrote:
> On Tue, Nov 10, 2020 at 3:00 PM Jeff Layton <jlayton@kernel.org> wrote:
> > 
> > On Tue, 2020-11-10 at 21:52 +0800, changcheng.liu@intel.com wrote:
> > > 1. monitor's default port is defined by CEPH_MON_PORT
> > > 2. CEPH_PORT_START & CEPH_PORT_LAST are not needed.
> > > 
> > > Signed-off-by: Changcheng Liu <changcheng.liu@aliyun.com>
> > > 
> > > diff --git a/include/linux/ceph/msgr.h b/include/linux/ceph/msgr.h
> > > index 1c1887206ffa..feff5a2dc33e 100644
> > > --- a/include/linux/ceph/msgr.h
> > > +++ b/include/linux/ceph/msgr.h
> > > @@ -7,15 +7,6 @@
> > > 
> > > 
> > >  #define CEPH_MON_PORT    6789  /* default monitor port */
> > > 
> > > 
> > > -/*
> > > - * client-side processes will try to bind to ports in this
> > > - * range, simply for the benefit of tools like nmap or wireshark
> > > - * that would like to identify the protocol.
> > > - */
> > > -#define CEPH_PORT_FIRST  6789
> > > -#define CEPH_PORT_START  6800  /* non-monitors start here */
> > > -#define CEPH_PORT_LAST   6900
> > > -
> > >  /*
> > >   * tcp connection banner.  include a protocol version. and adjust
> > >   * whenever the wire protocol changes.  try to keep this string length
> > 
> > Thanks! Merged into testing branch.
> 
> Jeff, the From address doesn't match the SOB address here.  A few
> weeks ago I asked Changcheng to resend because of this and it looks
> like he sent two copies of the same patch today.  The other one seems
> to be in order -- please drop this one.
> 


Ok, dropped.
-- 
Jeff Layton <jlayton@kernel.org>

