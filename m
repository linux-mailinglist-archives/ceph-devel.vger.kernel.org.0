Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6E966F2816
	for <lists+ceph-devel@lfdr.de>; Sun, 30 Apr 2023 10:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbjD3IkI (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 30 Apr 2023 04:40:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjD3IkH (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 30 Apr 2023 04:40:07 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D59A12E;
        Sun, 30 Apr 2023 01:40:05 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id a640c23a62f3a-94ed7e49541so237209766b.1;
        Sun, 30 Apr 2023 01:40:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682844003; x=1685436003;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I3Hvi+/q4RUZKL1A7LgyM+XkMkTIi9bnr2yqRkdk38g=;
        b=DON0nl7pmcNTQk7eKxlz5/W2nO6FKuY4MdAgP42JnI7sNJYkFV4xig2FXGO/FwGfyu
         fYAeXsjmPTKWQqHz+Ei8N+80esgjV5u36+M3Cypq5eVyBy+Vtn2WOFmzLQ8xH/Ovn11O
         SGMwwpmvOEbjXqaEdHRMuvORCiXC0WyAV8Zku9HrhuxW+0mG/sdxRcwUNoUrVTnyy+ou
         Z/9PHA3ebgqAYD/TFFat35R0RV489y3t+ojgd2hrHzT5X4KH9zuW2Vbr/e30foXvJtt3
         mAb6HhvbRDP8JA7c9EmxmO2qvjbpjru0YQdMsNyrF1cg8zxOD34eyMCfqHVTTN9ClKEa
         fuow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682844003; x=1685436003;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I3Hvi+/q4RUZKL1A7LgyM+XkMkTIi9bnr2yqRkdk38g=;
        b=lLpVull1c1WD5oy2JnYi0Smkuag8v1YQ/nWl3Ylwdu7GbhOk4LrpTj3YTLuPpVM/X0
         QN3btD/NqqbsyrKRV6m8icnOo8r0TBgZOORfEycsPQI9QPAZOi6oM08GSDCkjK+Dzg5c
         8ySghvZAphZDAdphNrPdqgesVOk6ctQ8ZK3+ZO/zVq+OCH8ERJt1RAaHIIZBdhmCjFCw
         O/5cQTqqqOJUu0cH9+hPcmDPcjbtxEiHem+bDUyta1pEgq0IH4VIe/i1dbnTHBsSEIY/
         4SWFbdYjXMbgzsWTVBLB8DU3EL5lg4t3k2LfU3TFqqcXwAlX5Z0opkWW23pK1n0M33TK
         GDBQ==
X-Gm-Message-State: AC+VfDwTX+aQwAEa0tBQ2TavpYS7PDrh6HPrOiye9I/xqh10Rfxr7rI+
        cNOpavYdUwmsQp7nSVqjDsU0aMshv/7wULIfZ6EBGylwKDQ=
X-Google-Smtp-Source: ACHHUZ6e1oJig7PJkA9vpA5ErPbQKBDXPcUiAWr1CX/+ahE8l/l6J017YD33pfCrTJBu6+8fKU1CTtH++xfzlLVIhVw=
X-Received: by 2002:a17:907:3686:b0:928:796d:71e8 with SMTP id
 bi6-20020a170907368600b00928796d71e8mr9913055ejc.3.1682844002544; Sun, 30 Apr
 2023 01:40:02 -0700 (PDT)
MIME-Version: 1.0
References: <20230418014506.95428-1-xiubli@redhat.com> <877cu9w9ti.fsf@brahms.olymp>
 <008bc17d-d5fb-107e-4405-ebacc1568890@redhat.com> <87r0sgt39x.fsf@brahms.olymp>
In-Reply-To: <87r0sgt39x.fsf@brahms.olymp>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Sun, 30 Apr 2023 10:39:50 +0200
Message-ID: <CAOi1vP_VH-w_09nHf4CtqcAv06_JhecZEXjGep3oEf9VSP=Hfw@mail.gmail.com>
Subject: Re: [PATCH v3] ceph: fix potential use-after-free bug when trimming caps
To:     =?UTF-8?Q?Lu=C3=ADs_Henriques?= <lhenriques@suse.de>
Cc:     Xiubo Li <xiubli@redhat.com>, ceph-devel@vger.kernel.org,
        jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Apr 20, 2023 at 3:22=E2=80=AFPM Lu=C3=ADs Henriques <lhenriques@sus=
e.de> wrote:
>
> Xiubo Li <xiubli@redhat.com> writes:
>
> > On 4/18/23 22:20, Lu=C3=ADs Henriques wrote:
> >> xiubli@redhat.com writes:
> >>
> >>> From: Xiubo Li <xiubli@redhat.com>
> >>>
> >>> When trimming the caps and just after the 'session->s_cap_lock' is
> >>> released in ceph_iterate_session_caps() the cap maybe removed by
> >>> another thread, and when using the stale cap memory in the callbacks
> >>> it will trigger use-after-free crash.
> >>>
> >>> We need to check the existence of the cap just after the 'ci->i_ceph_=
lock'
> >>> being acquired. And do nothing if it's already removed.
> >> Your patch seems to be OK, but I'll be honest: the locking is *so* com=
plex
> >> that I can say for sure it really solves any problem :-(
> >>
> >> ceph_put_cap() uses mdsc->caps_list_lock to protect the list, but I ca=
n't
> >> be sure that holding ci->i_ceph_lock will protect a race in the case
> >> you're trying to solve.
> >
> > The 'mdsc->caps_list_lock' will protect the members in mdsc:
> >
> >         /*
> >          * Cap reservations
> >          *
> >          * Maintain a global pool of preallocated struct ceph_caps, ref=
erenced
> >          * by struct ceph_caps_reservations.  This ensures that we prea=
llocate
> >          * memory needed to successfully process an MDS response. (If a=
n MDS
> >          * sends us cap information and we fail to process it, we will =
have
> >          * problems due to the client and MDS being out of sync.)
> >          *
> >          * Reservations are 'owned' by a ceph_cap_reservation context.
> >          */
> >         spinlock_t      caps_list_lock;
> >         struct          list_head caps_list; /* unused (reserved or
> >                                                 unreserved) */
> >         struct          list_head cap_wait_list;
> >         int             caps_total_count;    /* total caps allocated */
> >         int             caps_use_count;      /* in use */
> >         int             caps_use_max;        /* max used caps */
> >         int             caps_reserve_count;  /* unused, reserved */
> >         int             caps_avail_count;    /* unused, unreserved */
> >         int             caps_min_count;      /* keep at least this many
> >
> > Not protecting the cap list in session or inode.
> >
> >
> > And the racy is between the session's cap list and inode's cap rbtree a=
nd both
> > are holding the same 'cap' reference.
> >
> > So in 'ceph_iterate_session_caps()' after getting the 'cap' and releasi=
ng the
> > 'session->s_cap_lock', just before passing the 'cap' to _cb() another t=
hread
> > could continue and release the 'cap'. Then the 'cap' should be stale no=
w and
> > after being passed to _cb() the 'cap' when dereferencing it will crash =
the
> > kernel.
> >
> > And if the 'cap' is stale, it shouldn't exist in the inode's cap rbtree=
. Please
> > note the lock order will be:
> >
> > 1, spin_lock(&ci->i_ceph_lock)
> >
> > 2, spin_lock(&session->s_cap_lock)
> >
> >
> > Before:
> >
> > ThreadA: ThreadB:
> >
> > __ceph_remove_caps() -->
> >
> >     spin_lock(&ci->i_ceph_lock)
> >
> >     ceph_remove_cap() --> ceph_iterate_session_caps() -->
> >
> >         __ceph_remove_cap() --> spin_lock(&session->s_cap_lock);
> >
> > cap =3D list_entry(p, struct ceph_cap, session_caps);
> >
> > spin_unlock(&session->s_cap_lock);
> >
> >             spin_lock(&session->s_cap_lock);
> >
> >             // remove it from the session's cap list
> >
> >             list_del_init(&cap->session_caps);
> >
> >             spin_unlock(&session->s_cap_lock);
> >
> >             ceph_put_cap()
> >
> > trim_caps_cb('cap') -->   // the _cb() could be deferred after ThreadA =
finished
> > 'ceph_put_cap()'
> >
> > spin_unlock(&ci->i_ceph_lock) dreference cap->xxx will trigger crash
> >
> >
> >
> > With this patch:
> >
> > ThreadA: ThreadB:
> >
> > __ceph_remove_caps() -->
> >
> >     spin_lock(&ci->i_ceph_lock)
> >
> >     ceph_remove_cap() --> ceph_iterate_session_caps() -->
> >
> >         __ceph_remove_cap() --> spin_lock(&session->s_cap_lock);
> >
> > cap =3D list_entry(p, struct ceph_cap, session_caps);
> >
> > ci_node =3D &cap->ci_node;
> >
> > spin_unlock(&session->s_cap_lock);
> >
> >             spin_lock(&session->s_cap_lock);
> >
> >             // remove it from the session's cap list
> >
> >             list_del_init(&cap->session_caps);
> >
> >             spin_unlock(&session->s_cap_lock);
> >
> >             ceph_put_cap()
> >
> > trim_caps_cb('ci_node') -->
> >
> > spin_unlock(&ci->i_ceph_lock)
> >
> > spin_lock(&ci->i_ceph_lock)
> >
> > cap =3D rb_entry(ci_node, struct ceph_cap, ci_node);    // This is bugg=
y in this
> > version, we should use the 'mds' instead and I will fix it.
> >
> > if (!cap)  { release the spin lock and return directly }
> >
> > spin_unlock(&ci->i_ceph_lock)
>
> Thanks a lot for taking the time to explain all of this.  Much
> appreciated.  It all seems to make sense, and, again, I don't have any
> real objection to your patch.  It's just that I still find the whole
> locking to be too complex, and every change that is made to it looks like
> walking on a mine field :-)
>
> > While we should switch to use the 'mds' of the cap instead of the 'ci_n=
ode',
> > which is buggy. I will fix it in next version.
>
> Yeah, I've took a quick look at v4 and it looks like it fixes this.

Hi Lu=C3=ADs,

Do you mind if I put this down as a Reviewed-by? ;)

Thanks,

                Ilya
