Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27BDD1C433E
	for <lists+ceph-devel@lfdr.de>; Mon,  4 May 2020 19:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730433AbgEDRsv (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 4 May 2020 13:48:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728158AbgEDRsv (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 4 May 2020 13:48:51 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D7A1C061A0E
        for <ceph-devel@vger.kernel.org>; Mon,  4 May 2020 10:48:51 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id c18so12124142ile.5
        for <ceph-devel@vger.kernel.org>; Mon, 04 May 2020 10:48:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7YnCSPt7QlQ0UM9qOaVaToYyqKEHcIEN80MBUDyon5I=;
        b=pbgU8260WJBKbnjhi2+OKm6SlDr3aXaPIoeoyXOyF9eu6tgLzHpun2p444YfKGTMkl
         2tOAyg2QWeXDwZzf+WIFBzk+zM5IRRSSxuHcH1MOr1Z06N42rJRwZ8Ms+uFHqgHybZU+
         PcSp8JC0uoWoeCFwBU7gI8qfeNEn5Y499tG6we0El6Diifh03FZoGEBkoHwI4b9Iwqp1
         mDHcfClfIG6X4ZxdeODJyIVCPzDxx3cX7igs3ldtimT+1BqP03qfmtje2eV5LvENiuvH
         J2p6mrGIdtRS+MQL8hDDeJkz1zp5vLm6/UOaOHsh3itiBAB7jwrKPesVNLdu7xO2qaW2
         sU6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7YnCSPt7QlQ0UM9qOaVaToYyqKEHcIEN80MBUDyon5I=;
        b=Hwe5C5IdctH2m0c04vNE7MD2FEQFgH6vu67yZl6I+3gUPpT8F/4yJyLw0tp0i+JsgD
         RK5FPtq4gTPsFQA6VqKGG6t0vWcDMsUiGPle9fAbzMsQwXEnMSXyPJLSOYMIN40eIM/b
         2IhgWEmJBnKj7qtSBSfvaoQHEbby1G8UtKSBTsfdmijKODkE0afpxmTzJ1YEwAtjPYAg
         Q159iLF2VToLFxAPrS4+/BoD6cMPtklwblwQFmQee5VXZ4kPd4htoWcei8KZM8hgrVJz
         RzBnNkrOIkNyNmZwTQ6MkS3bqbhSoSxqmw89xIXMNzoyJRDSlkUDMNj/CVXvPSfvhc66
         ArDg==
X-Gm-Message-State: AGi0PubmNcYJLfdNpFiVW+5S0JB0Fz5kxnKrVgS4c1isIrvN8I76G1qX
        O1qzZC3v1pPXQsVaz8xcfpQ38U6IDLeFUw27aF3Gp6DLAMc=
X-Google-Smtp-Source: APiQypKo9qOTCnWfkIDUY2RUjOv1EPcuxYIiKuQ8LWC0GJMNNJablNBPJ7piyzi/OY8s9Tz/Q2VtEPAe3yQkOUMz3XA=
X-Received: by 2002:a92:9f4e:: with SMTP id u75mr15242908ili.282.1588614530518;
 Mon, 04 May 2020 10:48:50 -0700 (PDT)
MIME-Version: 1.0
References: <1588023986-23672-1-git-send-email-edward6@linux.ibm.com>
 <f36451800e4656f99483f4d47487a40ea5f942cd.camel@kernel.org>
 <d322ad5e-8409-7e5e-8d16-a2706223f26f@linux.ibm.com> <ea3dc3b2657a766f2fc253fe6b1bac08aeb968db.camel@kernel.org>
 <CAOi1vP-6sWTw68UJx4kV-0fmhLGE0=hw3ZYPYd8tp6aXVNYJXg@mail.gmail.com> <4f37cee17e39b03470ec3248cae44d3f0868ce0f.camel@kernel.org>
In-Reply-To: <4f37cee17e39b03470ec3248cae44d3f0868ce0f.camel@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 4 May 2020 19:48:52 +0200
Message-ID: <CAOi1vP-DO1jGKXx8R4As3pGtsOoWYS8SRcKU7jK=mr=FGSvB6Q@mail.gmail.com>
Subject: Re: [PATCH] ceph: fix up endian bug in managing feature bits
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        "Yan, Zheng" <ukernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Apr 30, 2020 at 3:03 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Wed, 2020-04-29 at 18:08 +0200, Ilya Dryomov wrote:
> > On Wed, Apr 29, 2020 at 5:42 PM Jeff Layton <jlayton@kernel.org> wrote:
> > > On Wed, 2020-04-29 at 11:46 +0200, Eduard Shishkin wrote:
> > > > On 4/28/20 2:23 PM, Jeff Layton wrote:
> > > > > On Mon, 2020-04-27 at 23:46 +0200, edward6@linux.ibm.com wrote:
> > > > > > From: Eduard Shishkin <edward6@linux.ibm.com>
> > > > > >
> > > > > > In the function handle_session() variable @features always
> > > > > > contains little endian order of bytes. Just because the feature
> > > > > > bits are packed bytewise from left to right in
> > > > > > encode_supported_features().
> > > > > >
> > > > > > However, test_bit(), called to check features availability, assumes
> > > > > > the host order of bytes in that variable. This leads to problems on
> > > > > > big endian architectures. Specifically it is impossible to mount
> > > > > > ceph volume on s390.
> > > > > >
> > > > > > This patch adds conversion from little endian to the host order
> > > > > > of bytes, thus fixing the problem.
> > > > > >
> > > > > > Signed-off-by: Eduard Shishkin <edward6@linux.ibm.com>
> > > > > > ---
> > > > > >   fs/ceph/mds_client.c | 4 ++--
> > > > > >   1 file changed, 2 insertions(+), 2 deletions(-)
> > > > > >
> > > > > > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > > > > > index 486f91f..190598d 100644
> > > > > > --- a/fs/ceph/mds_client.c
> > > > > > +++ b/fs/ceph/mds_client.c
> > > > > > @@ -3252,7 +3252,7 @@ static void handle_session(struct ceph_mds_session *session,
> > > > > >           struct ceph_mds_session_head *h;
> > > > > >           u32 op;
> > > > > >           u64 seq;
> > > > > > - unsigned long features = 0;
> > > > > > + __le64 features = 0;
> > > > > >           int wake = 0;
> > > > > >           bool blacklisted = false;
> > > > > >
> > > > > > @@ -3301,7 +3301,7 @@ static void handle_session(struct ceph_mds_session *session,
> > > > > >                   if (session->s_state == CEPH_MDS_SESSION_RECONNECTING)
> > > > > >                           pr_info("mds%d reconnect success\n", session->s_mds);
> > > > > >                   session->s_state = CEPH_MDS_SESSION_OPEN;
> > > > > > -         session->s_features = features;
> > > > > > +         session->s_features = le64_to_cpu(features);
> > > > > >                   renewed_caps(mdsc, session, 0);
> > > > > >                   wake = 1;
> > > > > >                   if (mdsc->stopping)
> > > > >
> > > > > (cc'ing Zheng since he did the original patches here)
> > > > >
> > > > > Thanks Eduard. The problem is real, but I think we can just do the
> > > > > conversion during the decode.
> > > > >
> > > > > The feature mask words sent by the MDS are 64 bits, so if it's smaller
> > > > > we can assume that it's malformed. So, I don't think we need to handle
> > > > > the case where it's smaller than 8 bytes.
> > > > >
> > > > > How about this patch instead?
> > > >
> > > > Hi Jeff,
> > > >
> > > > This also works. Please, apply.
> > > >
> > > > Thanks,
> > > > Eduard.
> > > >
> > >
> > > Thanks. Merged into ceph-client/testing branch, and should make v5.8.
> >
> > I think this is stable material.  I'll tag it and get it queued up for 5.7-rc.
> >
> > Thanks,
> >
>
> Yeah, that sounds reasonable.
>
> If you're going to send up another PR, then we might want to add these
> bugfixes currently in the testing branch to it as well:
>
> 445645c8be5f fs/ceph:fix special error code in ceph_try_get_caps()
> 591681748b56 fs/ceph:fix double unlock in handle_cap_export()
> 0e84a1ebe161 ceph: ceph_kick_flushing_caps needs the s_mutex
>
> I'm not sure that any of them need to go to stable though. We might also
> want this one though:
>
> 7b3facb61440 ceph: reset i_requested_max_size if file write is not wanted
>
> ...but it'll probably need to be reworked due to merge conflicts if we
> move it ahead of some of the cap handling cleanup patches (or we could
> just pull those in too).
>
> Zheng, do you have an opinion here? Should 7b3facb61440 go to stable?

(dropping IBM folks)

"ceph: ceph_kick_flushing_caps needs the s_mutex" doesn't apply
either because cap_dirty list was moved.  I don't see the urgency on
these TBH.

The endianness fix and two error handling fixups from Wu are now
queued up.

Thanks,

                Ilya
