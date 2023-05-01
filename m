Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5554E6F3040
	for <lists+ceph-devel@lfdr.de>; Mon,  1 May 2023 12:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232237AbjEAKhi (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 1 May 2023 06:37:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbjEAKhh (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 1 May 2023 06:37:37 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D10D6A8;
        Mon,  1 May 2023 03:37:35 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 4E0B122A14;
        Mon,  1 May 2023 10:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1682937454; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+USmuIu8nZgFSeGyPz1ENqL8sRj74XuW/hqALw8SSj8=;
        b=yEfejQmAFSNu3tS9Z6hgc4e6pHpmjBLaixJuAr8D3iHDNNpgzI9cNtZD7Ndi90s77Lz9KA
        37r1ZlDgMWuaxEyLpUXbpFp0aIuWHb5AwUdiThjVKI9tIJpMvY1b5voaf6TNt+D+CQFOFn
        KcTwddl/Lm+EFszDXqLDWl6TiA3N2m8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1682937454;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+USmuIu8nZgFSeGyPz1ENqL8sRj74XuW/hqALw8SSj8=;
        b=ZERuFFx9U1fgSTro+P4f6UMOQUJK/QCoHElIdDnWLwBqL6dYoh1W9L0/u8aC80L7PxnG5b
        GBUwwo3DD8m0ULDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D0DCA13587;
        Mon,  1 May 2023 10:37:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id u58JMG2WT2SIMwAAMHmgww
        (envelope-from <lhenriques@suse.de>); Mon, 01 May 2023 10:37:33 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id a40b48ce;
        Mon, 1 May 2023 10:37:29 +0000 (UTC)
From:   =?utf-8?Q?Lu=C3=ADs_Henriques?= <lhenriques@suse.de>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Xiubo Li <xiubli@redhat.com>, ceph-devel@vger.kernel.org,
        jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] ceph: fix potential use-after-free bug when trimming
 caps
References: <20230418014506.95428-1-xiubli@redhat.com>
        <877cu9w9ti.fsf@brahms.olymp>
        <008bc17d-d5fb-107e-4405-ebacc1568890@redhat.com>
        <87r0sgt39x.fsf@brahms.olymp>
        <CAOi1vP_VH-w_09nHf4CtqcAv06_JhecZEXjGep3oEf9VSP=Hfw@mail.gmail.com>
Date:   Mon, 01 May 2023 11:37:28 +0100
In-Reply-To: <CAOi1vP_VH-w_09nHf4CtqcAv06_JhecZEXjGep3oEf9VSP=Hfw@mail.gmail.com>
        (Ilya Dryomov's message of "Sun, 30 Apr 2023 10:39:50 +0200")
Message-ID: <878re8tk0n.fsf@brahms.olymp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Ilya Dryomov <idryomov@gmail.com> writes:

> On Wed, Apr 20, 2023 at 3:22=E2=80=AFPM Lu=C3=ADs Henriques <lhenriques@s=
use.de> wrote:
>>
>> Xiubo Li <xiubli@redhat.com> writes:
>>
>> > On 4/18/23 22:20, Lu=C3=ADs Henriques wrote:
>> >> xiubli@redhat.com writes:
>> >>
>> >>> From: Xiubo Li <xiubli@redhat.com>
>> >>>
>> >>> When trimming the caps and just after the 'session->s_cap_lock' is
>> >>> released in ceph_iterate_session_caps() the cap maybe removed by
>> >>> another thread, and when using the stale cap memory in the callbacks
>> >>> it will trigger use-after-free crash.
>> >>>
>> >>> We need to check the existence of the cap just after the 'ci->i_ceph=
_lock'
>> >>> being acquired. And do nothing if it's already removed.
>> >> Your patch seems to be OK, but I'll be honest: the locking is *so* co=
mplex
>> >> that I can say for sure it really solves any problem :-(
>> >>
>> >> ceph_put_cap() uses mdsc->caps_list_lock to protect the list, but I c=
an't
>> >> be sure that holding ci->i_ceph_lock will protect a race in the case
>> >> you're trying to solve.
>> >
>> > The 'mdsc->caps_list_lock' will protect the members in mdsc:
>> >
>> >         /*
>> >          * Cap reservations
>> >          *
>> >          * Maintain a global pool of preallocated struct ceph_caps, re=
ferenced
>> >          * by struct ceph_caps_reservations.  This ensures that we pre=
allocate
>> >          * memory needed to successfully process an MDS response. (If =
an MDS
>> >          * sends us cap information and we fail to process it, we will=
 have
>> >          * problems due to the client and MDS being out of sync.)
>> >          *
>> >          * Reservations are 'owned' by a ceph_cap_reservation context.
>> >          */
>> >         spinlock_t      caps_list_lock;
>> >         struct          list_head caps_list; /* unused (reserved or
>> >                                                 unreserved) */
>> >         struct          list_head cap_wait_list;
>> >         int             caps_total_count;    /* total caps allocated */
>> >         int             caps_use_count;      /* in use */
>> >         int             caps_use_max;        /* max used caps */
>> >         int             caps_reserve_count;  /* unused, reserved */
>> >         int             caps_avail_count;    /* unused, unreserved */
>> >         int             caps_min_count;      /* keep at least this many
>> >
>> > Not protecting the cap list in session or inode.
>> >
>> >
>> > And the racy is between the session's cap list and inode's cap rbtree =
and both
>> > are holding the same 'cap' reference.
>> >
>> > So in 'ceph_iterate_session_caps()' after getting the 'cap' and releas=
ing the
>> > 'session->s_cap_lock', just before passing the 'cap' to _cb() another =
thread
>> > could continue and release the 'cap'. Then the 'cap' should be stale n=
ow and
>> > after being passed to _cb() the 'cap' when dereferencing it will crash=
 the
>> > kernel.
>> >
>> > And if the 'cap' is stale, it shouldn't exist in the inode's cap rbtre=
e. Please
>> > note the lock order will be:
>> >
>> > 1, spin_lock(&ci->i_ceph_lock)
>> >
>> > 2, spin_lock(&session->s_cap_lock)
>> >
>> >
>> > Before:
>> >
>> > ThreadA: ThreadB:
>> >
>> > __ceph_remove_caps() -->
>> >
>> >     spin_lock(&ci->i_ceph_lock)
>> >
>> >     ceph_remove_cap() --> ceph_iterate_session_caps() -->
>> >
>> >         __ceph_remove_cap() --> spin_lock(&session->s_cap_lock);
>> >
>> > cap =3D list_entry(p, struct ceph_cap, session_caps);
>> >
>> > spin_unlock(&session->s_cap_lock);
>> >
>> >             spin_lock(&session->s_cap_lock);
>> >
>> >             // remove it from the session's cap list
>> >
>> >             list_del_init(&cap->session_caps);
>> >
>> >             spin_unlock(&session->s_cap_lock);
>> >
>> >             ceph_put_cap()
>> >
>> > trim_caps_cb('cap') -->   // the _cb() could be deferred after ThreadA=
 finished
>> > 'ceph_put_cap()'
>> >
>> > spin_unlock(&ci->i_ceph_lock) dreference cap->xxx will trigger crash
>> >
>> >
>> >
>> > With this patch:
>> >
>> > ThreadA: ThreadB:
>> >
>> > __ceph_remove_caps() -->
>> >
>> >     spin_lock(&ci->i_ceph_lock)
>> >
>> >     ceph_remove_cap() --> ceph_iterate_session_caps() -->
>> >
>> >         __ceph_remove_cap() --> spin_lock(&session->s_cap_lock);
>> >
>> > cap =3D list_entry(p, struct ceph_cap, session_caps);
>> >
>> > ci_node =3D &cap->ci_node;
>> >
>> > spin_unlock(&session->s_cap_lock);
>> >
>> >             spin_lock(&session->s_cap_lock);
>> >
>> >             // remove it from the session's cap list
>> >
>> >             list_del_init(&cap->session_caps);
>> >
>> >             spin_unlock(&session->s_cap_lock);
>> >
>> >             ceph_put_cap()
>> >
>> > trim_caps_cb('ci_node') -->
>> >
>> > spin_unlock(&ci->i_ceph_lock)
>> >
>> > spin_lock(&ci->i_ceph_lock)
>> >
>> > cap =3D rb_entry(ci_node, struct ceph_cap, ci_node);    // This is bug=
gy in this
>> > version, we should use the 'mds' instead and I will fix it.
>> >
>> > if (!cap)  { release the spin lock and return directly }
>> >
>> > spin_unlock(&ci->i_ceph_lock)
>>
>> Thanks a lot for taking the time to explain all of this.  Much
>> appreciated.  It all seems to make sense, and, again, I don't have any
>> real objection to your patch.  It's just that I still find the whole
>> locking to be too complex, and every change that is made to it looks like
>> walking on a mine field :-)
>>
>> > While we should switch to use the 'mds' of the cap instead of the 'ci_=
node',
>> > which is buggy. I will fix it in next version.
>>
>> Yeah, I've took a quick look at v4 and it looks like it fixes this.
>
> Hi Lu=C3=ADs,
>
> Do you mind if I put this down as a Reviewed-by? ;)

Sure, feel free to add my

Reviewed-by: Lu=C3=ADs Henriques <lhenriques@suse.de>

(Sorry, forgot to send that explicitly.)

Cheers,
--=20
Lu=C3=ADs
