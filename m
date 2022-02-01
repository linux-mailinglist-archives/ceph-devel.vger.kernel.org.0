Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CF094A6068
	for <lists+ceph-devel@lfdr.de>; Tue,  1 Feb 2022 16:46:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240517AbiBAPq1 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 1 Feb 2022 10:46:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240503AbiBAPq0 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 1 Feb 2022 10:46:26 -0500
Received: from mail-vk1-xa31.google.com (mail-vk1-xa31.google.com [IPv6:2607:f8b0:4864:20::a31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83071C061714
        for <ceph-devel@vger.kernel.org>; Tue,  1 Feb 2022 07:46:26 -0800 (PST)
Received: by mail-vk1-xa31.google.com with SMTP id u25so7403343vkk.3
        for <ceph-devel@vger.kernel.org>; Tue, 01 Feb 2022 07:46:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lGr7vXi4LyjVd7bGc36FxSyZTh7JvhRdqnypMAtdf+s=;
        b=YyE3JgXJW/ul3dFVY87ZNRG6YTzFva1cKtkW2cBu/7uMvAmhYLjLgDayCvfN7S/G+d
         bT42BEFyapgGzCiVNjdKSjDP0lDaCASjM2koy9umCweYg0os55XaKA9jXXhCAP9Qaik0
         E45P1VfyxoJJe4EVMOtZUwyKqAWuOG5WmbuqJP/HweH1HnYeB8jPgd3oKAkZWd5vdfr8
         VTYqsPchacCWWGkvD1EdM/DLc6Qb4qq6jRIC3jqxn7W1qNdy0mRPS8wLe0NcKn0GG9Xx
         SNzFEGb9d4NayIKUtwMg3zlsilK0buDz537YGCmQcyorVr6NngEqrfjhqXMTr1XqWyIe
         oQEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lGr7vXi4LyjVd7bGc36FxSyZTh7JvhRdqnypMAtdf+s=;
        b=F6DdnG1/tttMuvgM2NL/T58W0D9JLDjY6huEFBY9dVfozWLwADVzgQOBQWUo/EwBhR
         Ycy/FD3ntAo+/nKYAeb0JtV3u8S5eR6PMNgBuh+RTqSj5aiaaYPDbIKZYxv7a3gniZyQ
         GoS0Eydm5ME9w8WuNJy2bvYt/H8NSzeuloiBJjF//sJWgp7tShTD+2/CToApbGdkQQeo
         +ZgBVDzfckqEyCmdp6Y3PbFYzejhYGZEu6/ipidEmkRh0VUuNQVV0I/exJUrAbOMjgpI
         fIKY8nivk/WnmO4/hCk4P0z8oGF+iZM5r1Lcor8KcB8jkCz+4LhqXcjXFOIZJtSMK8/X
         E5/w==
X-Gm-Message-State: AOAM530YQU2D8DkyFzoyDgGK6JjuuV6pv6VIRpQCNw9KXNu3hW2XhtAI
        WVEEDsAler/vVVPq7ds/0SNsfSau2GLioe5Hl0w=
X-Google-Smtp-Source: ABdhPJzhDvjxHO4rc6SvKWngqgf53Gsef3tVObhyLnjtqZ4+LliPaXwHMcFFXpKBgqQNcIWLp4yf5MT/BsoGG1Rte4c=
X-Received: by 2002:ac5:c7c3:: with SMTP id e3mr1123904vkn.1.1643730385496;
 Tue, 01 Feb 2022 07:46:25 -0800 (PST)
MIME-Version: 1.0
References: <20220131155846.32411-1-idryomov@gmail.com> <20220131155846.32411-3-idryomov@gmail.com>
 <04c35b85035fdce2678c78b430f18cab1a571a10.camel@kernel.org>
In-Reply-To: <04c35b85035fdce2678c78b430f18cab1a571a10.camel@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 1 Feb 2022 16:46:37 +0100
Message-ID: <CAOi1vP-846A_aFigP5E34ixg+ucCLL=w=QhsUFMU6qhy6V0Rww@mail.gmail.com>
Subject: Re: [PATCH 2/2] libceph: optionally use bounce buffer on recv path in
 crc mode
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Feb 1, 2022 at 2:24 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Mon, 2022-01-31 at 16:58 +0100, Ilya Dryomov wrote:
> > Both msgr1 and msgr2 in crc mode are zero copy in the sense that
> > message data is read from the socket directly into the destination
> > buffer.  We assume that the destination buffer is stable (i.e. remains
> > unchanged while it is being read to) though.  Otherwise, CRC errors
> > ensue:
> >
> >   libceph: read_partial_message 0000000048edf8ad data crc 1063286393 != exp. 228122706
> >   libceph: osd1 (1)192.168.122.1:6843 bad crc/signature
> >
> >   libceph: bad data crc, calculated 57958023, expected 1805382778
> >   libceph: osd2 (2)192.168.122.1:6876 integrity error, bad crc
> >
> > Introduce rxbounce option to enable use of a bounce buffer when
> > receiving message data.  In particular this is needed if a mapped
> > image is a Windows VM disk, passed to QEMU.  Windows has a system-wide
> > "dummy" page that may be mapped into the destination buffer (potentially
> > more than once into the same buffer) by the Windows Memory Manager in
> > an effort to generate a single large I/O [1][2].  QEMU makes a point of
> > preserving overlap relationships when cloning I/O vectors, so krbd gets
> > exposed to this behaviour.
> >
> > [1] "What Is Really in That MDL?"
> >     https://docs.microsoft.com/en-us/previous-versions/windows/hardware/design/dn614012(v=vs.85)
> > [2] https://blogs.msmvps.com/kernelmustard/2005/05/04/dummy-pages/
> >
> > URL: https://bugzilla.redhat.com/show_bug.cgi?id=1973317
> > Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> > ---
> >  include/linux/ceph/libceph.h   |  1 +
> >  include/linux/ceph/messenger.h |  1 +
> >  net/ceph/ceph_common.c         |  7 ++++
> >  net/ceph/messenger.c           |  4 +++
> >  net/ceph/messenger_v1.c        | 54 +++++++++++++++++++++++++++----
> >  net/ceph/messenger_v2.c        | 58 ++++++++++++++++++++++++++--------
> >  6 files changed, 105 insertions(+), 20 deletions(-)
> >
> > diff --git a/include/linux/ceph/libceph.h b/include/linux/ceph/libceph.h
> > index 6a89ea410e43..edf62eaa6285 100644
> > --- a/include/linux/ceph/libceph.h
> > +++ b/include/linux/ceph/libceph.h
> > @@ -35,6 +35,7 @@
> >  #define CEPH_OPT_TCP_NODELAY      (1<<4) /* TCP_NODELAY on TCP sockets */
> >  #define CEPH_OPT_NOMSGSIGN        (1<<5) /* don't sign msgs (msgr1) */
> >  #define CEPH_OPT_ABORT_ON_FULL    (1<<6) /* abort w/ ENOSPC when full */
> > +#define CEPH_OPT_RXBOUNCE         (1<<7) /* double-buffer read data */
> >
> >  #define CEPH_OPT_DEFAULT   (CEPH_OPT_TCP_NODELAY)
> >
> > diff --git a/include/linux/ceph/messenger.h b/include/linux/ceph/messenger.h
> > index 6c6b6ea52bb8..e7f2fb2fc207 100644
> > --- a/include/linux/ceph/messenger.h
> > +++ b/include/linux/ceph/messenger.h
> > @@ -461,6 +461,7 @@ struct ceph_connection {
> >       struct ceph_msg *out_msg;        /* sending message (== tail of
> >                                           out_sent) */
> >
> > +     struct page *bounce_page;
> >       u32 in_front_crc, in_middle_crc, in_data_crc;  /* calculated crc */
> >
> >       struct timespec64 last_keepalive_ack; /* keepalive2 ack stamp */
> > diff --git a/net/ceph/ceph_common.c b/net/ceph/ceph_common.c
> > index ecc400a0b7bb..4c6441536d55 100644
> > --- a/net/ceph/ceph_common.c
> > +++ b/net/ceph/ceph_common.c
> > @@ -246,6 +246,7 @@ enum {
> >       Opt_cephx_sign_messages,
> >       Opt_tcp_nodelay,
> >       Opt_abort_on_full,
> > +     Opt_rxbounce,
> >  };
> >
> >  enum {
> > @@ -295,6 +296,7 @@ static const struct fs_parameter_spec ceph_parameters[] = {
> >       fsparam_u32     ("osdkeepalive",                Opt_osdkeepalivetimeout),
> >       fsparam_enum    ("read_from_replica",           Opt_read_from_replica,
> >                        ceph_param_read_from_replica),
> > +     fsparam_flag    ("rxbounce",                    Opt_rxbounce),
>
> Yuck.
>
> It sure would be nice to automagically detect when this was needed
> somehow. The option is fine once you know you need it, but getting to
> that point may be painful.

I'm updating the man page in [1].  I should probably expand rxbounce
paragraph with the exact error strings -- that should make it easy to
find for anyone interested.

>
> Maybe we should we make the warnings about failing crc messages suggest
> rxbounce? We could also consider making it so that when you fail a crc
> check and the connection is reset, that the new connection enables
> rxbounce automatically?

Do you envision that happening after just a single checksum mismatch?
For that particular connection or globally?  If we decide to do that,
I think it should be global (just because currently all connection
settings are global) but then some sort of threshold is going to be
needed...

[1] https://github.com/ceph/ceph/pull/44842/files#diff-90064d9b1388dcb61bb57ff61f60443b15ef3d74f31fef7f63e43b5ae3a03f37

Thanks,

                Ilya
