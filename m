Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDDE74A6279
	for <lists+ceph-devel@lfdr.de>; Tue,  1 Feb 2022 18:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234385AbiBARaU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 1 Feb 2022 12:30:20 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34558 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbiBARaU (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 1 Feb 2022 12:30:20 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 273F5B82ECC
        for <ceph-devel@vger.kernel.org>; Tue,  1 Feb 2022 17:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AD5CC340EB;
        Tue,  1 Feb 2022 17:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643736617;
        bh=3ptR7dFYT8roJbY2XBtN16t2KrQ4fDDwCt0DCRGNR00=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=llOCJJIJzcRIrmR50Di3ZV5f271E+UNyWdrbCnmBD1BjtvQl24jTyD2vKlHq+kzNA
         YnLdIv12SvUOdtnn5Fi8rBLlKruM+CsPS01N5FRCAT6hO7VLhLrousiKJAVEofwPF3
         cuY8EWLi/Su4gF+FIVkhCWMjJwvMYcY/YLUQAUe0k3GrY3VjeIirBcgzmmyc2p3jts
         yAqYSMKUOyxtTY3UtOJA3W/vjbKvtox1GGv/gNoZpAPQpsj6wiX4h1u3ExvUrj3e8o
         IQGpLj473ZL0He2A6qatmScxWtgzrFXmKu7dpq0cLMzNiIzsaC2fu9veN+j4Ltxq8d
         sEi3KPp0DbFBw==
Message-ID: <894a36483c241e0cc5154e09e8dd078f57a606d5.camel@kernel.org>
Subject: Re: [PATCH 2/2] libceph: optionally use bounce buffer on recv path
 in crc mode
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Date:   Tue, 01 Feb 2022 12:30:16 -0500
In-Reply-To: <CAOi1vP-846A_aFigP5E34ixg+ucCLL=w=QhsUFMU6qhy6V0Rww@mail.gmail.com>
References: <20220131155846.32411-1-idryomov@gmail.com>
         <20220131155846.32411-3-idryomov@gmail.com>
         <04c35b85035fdce2678c78b430f18cab1a571a10.camel@kernel.org>
         <CAOi1vP-846A_aFigP5E34ixg+ucCLL=w=QhsUFMU6qhy6V0Rww@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.3 (3.42.3-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2022-02-01 at 16:46 +0100, Ilya Dryomov wrote:
> On Tue, Feb 1, 2022 at 2:24 PM Jeff Layton <jlayton@kernel.org> wrote:
> > 
> > On Mon, 2022-01-31 at 16:58 +0100, Ilya Dryomov wrote:
> > > Both msgr1 and msgr2 in crc mode are zero copy in the sense that
> > > message data is read from the socket directly into the destination
> > > buffer.  We assume that the destination buffer is stable (i.e. remains
> > > unchanged while it is being read to) though.  Otherwise, CRC errors
> > > ensue:
> > > 
> > >   libceph: read_partial_message 0000000048edf8ad data crc 1063286393 != exp. 228122706
> > >   libceph: osd1 (1)192.168.122.1:6843 bad crc/signature
> > > 
> > >   libceph: bad data crc, calculated 57958023, expected 1805382778
> > >   libceph: osd2 (2)192.168.122.1:6876 integrity error, bad crc
> > > 
> > > Introduce rxbounce option to enable use of a bounce buffer when
> > > receiving message data.  In particular this is needed if a mapped
> > > image is a Windows VM disk, passed to QEMU.  Windows has a system-wide
> > > "dummy" page that may be mapped into the destination buffer (potentially
> > > more than once into the same buffer) by the Windows Memory Manager in
> > > an effort to generate a single large I/O [1][2].  QEMU makes a point of
> > > preserving overlap relationships when cloning I/O vectors, so krbd gets
> > > exposed to this behaviour.
> > > 
> > > [1] "What Is Really in That MDL?"
> > >     https://docs.microsoft.com/en-us/previous-versions/windows/hardware/design/dn614012(v=vs.85)
> > > [2] https://blogs.msmvps.com/kernelmustard/2005/05/04/dummy-pages/
> > > 
> > > URL: https://bugzilla.redhat.com/show_bug.cgi?id=1973317
> > > Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> > > ---
> > >  include/linux/ceph/libceph.h   |  1 +
> > >  include/linux/ceph/messenger.h |  1 +
> > >  net/ceph/ceph_common.c         |  7 ++++
> > >  net/ceph/messenger.c           |  4 +++
> > >  net/ceph/messenger_v1.c        | 54 +++++++++++++++++++++++++++----
> > >  net/ceph/messenger_v2.c        | 58 ++++++++++++++++++++++++++--------
> > >  6 files changed, 105 insertions(+), 20 deletions(-)
> > > 
> > > diff --git a/include/linux/ceph/libceph.h b/include/linux/ceph/libceph.h
> > > index 6a89ea410e43..edf62eaa6285 100644
> > > --- a/include/linux/ceph/libceph.h
> > > +++ b/include/linux/ceph/libceph.h
> > > @@ -35,6 +35,7 @@
> > >  #define CEPH_OPT_TCP_NODELAY      (1<<4) /* TCP_NODELAY on TCP sockets */
> > >  #define CEPH_OPT_NOMSGSIGN        (1<<5) /* don't sign msgs (msgr1) */
> > >  #define CEPH_OPT_ABORT_ON_FULL    (1<<6) /* abort w/ ENOSPC when full */
> > > +#define CEPH_OPT_RXBOUNCE         (1<<7) /* double-buffer read data */
> > > 
> > >  #define CEPH_OPT_DEFAULT   (CEPH_OPT_TCP_NODELAY)
> > > 
> > > diff --git a/include/linux/ceph/messenger.h b/include/linux/ceph/messenger.h
> > > index 6c6b6ea52bb8..e7f2fb2fc207 100644
> > > --- a/include/linux/ceph/messenger.h
> > > +++ b/include/linux/ceph/messenger.h
> > > @@ -461,6 +461,7 @@ struct ceph_connection {
> > >       struct ceph_msg *out_msg;        /* sending message (== tail of
> > >                                           out_sent) */
> > > 
> > > +     struct page *bounce_page;
> > >       u32 in_front_crc, in_middle_crc, in_data_crc;  /* calculated crc */
> > > 
> > >       struct timespec64 last_keepalive_ack; /* keepalive2 ack stamp */
> > > diff --git a/net/ceph/ceph_common.c b/net/ceph/ceph_common.c
> > > index ecc400a0b7bb..4c6441536d55 100644
> > > --- a/net/ceph/ceph_common.c
> > > +++ b/net/ceph/ceph_common.c
> > > @@ -246,6 +246,7 @@ enum {
> > >       Opt_cephx_sign_messages,
> > >       Opt_tcp_nodelay,
> > >       Opt_abort_on_full,
> > > +     Opt_rxbounce,
> > >  };
> > > 
> > >  enum {
> > > @@ -295,6 +296,7 @@ static const struct fs_parameter_spec ceph_parameters[] = {
> > >       fsparam_u32     ("osdkeepalive",                Opt_osdkeepalivetimeout),
> > >       fsparam_enum    ("read_from_replica",           Opt_read_from_replica,
> > >                        ceph_param_read_from_replica),
> > > +     fsparam_flag    ("rxbounce",                    Opt_rxbounce),
> > 
> > Yuck.
> > 
> > It sure would be nice to automagically detect when this was needed
> > somehow. The option is fine once you know you need it, but getting to
> > that point may be painful.
> 
> I'm updating the man page in [1].  I should probably expand rxbounce
> paragraph with the exact error strings -- that should make it easy to
> find for anyone interested.
> 

Fair enough. That seems like the reasonable place to start.

> > 
> > Maybe we should we make the warnings about failing crc messages suggest
> > rxbounce? We could also consider making it so that when you fail a crc
> > check and the connection is reset, that the new connection enables
> > rxbounce automatically?
> 
> Do you envision that happening after just a single checksum mismatch?
> For that particular connection or globally?  If we decide to do that,
> I think it should be global (just because currently all connection
> settings are global) but then some sort of threshold is going to be
> needed...
> 

I don't know. I didn't really think through all of the potential issues.
Probably we should just wait to see how big a problem this is before we
do anything automatic.

> [1] https://github.com/ceph/ceph/pull/44842/files#diff-90064d9b1388dcb61bb57ff61f60443b15ef3d74f31fef7f63e43b5ae3a03f37
> 
> Thanks,
> 
>                 Ilya


-- 
Jeff Layton <jlayton@kernel.org>
