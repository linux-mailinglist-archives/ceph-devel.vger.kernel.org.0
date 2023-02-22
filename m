Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F292A69FACE
	for <lists+ceph-devel@lfdr.de>; Wed, 22 Feb 2023 19:10:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232364AbjBVSKB (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 22 Feb 2023 13:10:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231867AbjBVSKA (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 22 Feb 2023 13:10:00 -0500
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 496E72DE53
        for <ceph-devel@vger.kernel.org>; Wed, 22 Feb 2023 10:09:52 -0800 (PST)
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com [209.85.128.199])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 83F1A3F20F
        for <ceph-devel@vger.kernel.org>; Wed, 22 Feb 2023 18:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1677089390;
        bh=49YVhYm5lCt7I5fcbk/Qk9lag15/+Ha89NYllnr9a2M=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=Np3eA/Y/EHVIAxIoYM/+fxrzSU0bDcLd6n/wFhpWMc55NOP8PpXI8XCSTewX6DrJX
         i6Q80j3+8s+/1vT4lmqotBJb4CFVj7FR/6z6S4gp2ohBJXBG669OYE+iF3PRAaCRYT
         4VOLvH3QBeHR6XFEDi0KZFhgsSYXLjjOoT0b9jHnVB/eGVjFTISZIzn9ymPXTLPq+k
         rCqOMqidemBCMruNrMtBqrpRKkckn4V+lxI4Tf3FuM6AtBWlpOs3Ee7s+qhI9aJvKZ
         aAtbYdv9VEB4AWwHah5m7KTQlCuxzeMexaKmA4kELpjSmtchwtqO28EPjEaiQOZBVl
         PGSiTQscNy0jg==
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-536c039f859so80552097b3.21
        for <ceph-devel@vger.kernel.org>; Wed, 22 Feb 2023 10:09:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=49YVhYm5lCt7I5fcbk/Qk9lag15/+Ha89NYllnr9a2M=;
        b=04tOlLyw2v1Ntwj32Q4jWF6PyHdI6d5PbxTrKzNrgqmc+wy3XkfmRZEabBYGaJYkjn
         vSqP5Z7MNvKnKMnKA/aufoet2dRNuwhONqCJPsk7NnDhd3wStQ83xUf4cs8WStVNSvfG
         MFcJe8EE9zStQWXjKziVBUpOfKN9vC5MkGB6hLDK/dI26pl74pcbdPdpBSYDTV3wrKmv
         wBTrtvQMit2L/sX2bf8eI7otKm1v26fdpo844OFgyxdsZU9cJr8jeKaHOd/WCb6GkKY0
         7it1Ezsn3Ywhp8trf06uKwP3tAODRlWPrRpvP2skG5t5n7VSm3u54zRdbiMB/wM7HF3t
         19kg==
X-Gm-Message-State: AO0yUKUHMxCwVpSLu6XlqhkXIOMM61Zn8KMzEstDGh7OZQBj4dVCLJHw
        4XmLMBvFUklErOIsx6Fq9H9KwKMSm+sgnCF7L06ssMjB9Dcn09qgmIodxpuntDNV9cbzTLtZ29n
        3T9j39h1jbvDGoeMqnJfrjLW01lwL0T2qjbH9empKOjLYE7iB10Qjt2i45OsS7Ks=
X-Received: by 2002:a5b:b82:0:b0:80b:5398:3aeb with SMTP id l2-20020a5b0b82000000b0080b53983aebmr1007283ybq.300.1677089388627;
        Wed, 22 Feb 2023 10:09:48 -0800 (PST)
X-Google-Smtp-Source: AK7set+mEayYGuYSmP/g5yxdiY6huTkK739Y+6gP0l+5Z+nBGajg4DNkMVyZSUuu6gtMzWTTb8Jk82ozQRXtq2/OY5Q=
X-Received: by 2002:a5b:b82:0:b0:80b:5398:3aeb with SMTP id
 l2-20020a5b0b82000000b0080b53983aebmr1007279ybq.300.1677089388358; Wed, 22
 Feb 2023 10:09:48 -0800 (PST)
MIME-Version: 1.0
References: <CAEivzxdru7eW=DZ=UaSuisa5X2_HHtwfT-_q3+-YmpAty+p-dw@mail.gmail.com>
 <CAOi1vP_OHYoSfhJvUk1Nsta=NLLZcyxHLGvjoACTT-VC-e=Y_w@mail.gmail.com>
 <CAEivzxc4YTt29ZtzGpa3Q9_dnm-mGYa0qE-iEsVedOCfF2WBzA@mail.gmail.com> <CAOi1vP-U0GKENogq3QF3x=zo14fCPUdk=yU5sHzPK99KKXH4Kw@mail.gmail.com>
In-Reply-To: <CAOi1vP-U0GKENogq3QF3x=zo14fCPUdk=yU5sHzPK99KKXH4Kw@mail.gmail.com>
From:   Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Date:   Wed, 22 Feb 2023 19:09:37 +0100
Message-ID: <CAEivzxd0YC3fGMTFzfQZXS1Q9+86BCCWO9RSs2LYhCCkUBBUww@mail.gmail.com>
Subject: Re: EBLOCKLISTED error after rbd map was interrupted by fatal signal
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org,
        =?UTF-8?Q?St=C3=A9phane_Graber?= <stgraber@ubuntu.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Feb 22, 2023 at 6:41 PM Ilya Dryomov <idryomov@gmail.com> wrote:
>
> On Wed, Feb 22, 2023 at 3:07 PM Aleksandr Mikhalitsyn
> <aleksandr.mikhalitsyn@canonical.com> wrote:
> >
> > On Wed, Feb 22, 2023 at 2:38 PM Ilya Dryomov <idryomov@gmail.com> wrote:
> > >
> > > On Wed, Feb 22, 2023 at 1:17 PM Aleksandr Mikhalitsyn
> > > <aleksandr.mikhalitsyn@canonical.com> wrote:
> > > >
> > > > Hi folks,
> > > >
> > > > Recently we've met a problem [1] with the kernel ceph client/rbd.
> > > >
> > > > Writing to /sys/bus/rbd/add_single_major in some cases can take a lot
> > > > of time, so on the userspace side
> > > > we had a timeout and sent a fatal signal to the rbd map process to
> > > > interrupt the process.
> > > > And this working perfectly well, but then it's impossible to perform
> > > > rbd map again cause we are always getting EBLOCKLISTED error.
> > >
> > > Hi Aleksandr,
> >
> > Hi Ilya!
> >
> > Thanks a lot for such a fast reply.
> >
> > >
> > > I'm not sure if there is a causal relationship between "rbd map"
> > > getting sent a fatal signal by LXC and these EBLOCKLISTED errors.  Are
> > > you saying that that was confirmed to be the root cause, meaning that
> > > no such errors were observed after [1] got merged?
> >
> > AFAIK, no. After [1] was merged we haven't seen any issues with rbd.
> > I think Stephane will correct me if I'm wrong.
> >
> > I also can't be fully sure that there is a strict logical relationship
> > between EBLOCKLISTED error and fatal signal.
> > After I got a report from LXD folks about this I've tried to analyse
> > kernel code and find the places where
> > EBLOCKLISTED (ESHUTDOWN|EBLOCKLISTED|EBLACKLISTED) can be sent to the userspace.
> > I was surprised that there are no places in the kernel ceph/rbd client
> > where we can throw this error, it can only
> > be received from ceph monitor as a reply to a kernel client request.
> > But we have a lot of checks like this:
> > if (rc == -EBLOCKLISTED)
> >       fsc->blocklisted = true;
> > so, if we receive this error once then it will be saved in struct
> > ceph_fs_client without any chance to clear it.
>
> This is CephFS code, not RBD.

Ah, yep. :)

For RBD we save errno in wake_lock_waiters() function:
/*
* Either image request state machine(s) or rbd_add_acquire_lock()
* (i.e. "rbd map").
*/
static void wake_lock_waiters(struct rbd_device *rbd_dev, int result)
{
...
     if (!completion_done(&rbd_dev->acquire_wait)) {
     rbd_assert(list_empty(&rbd_dev->acquiring_list) &&
     list_empty(&rbd_dev->running_list));
          rbd_dev->acquire_err = result; <== HERE

But it's not a problem.

>
> > Maybe this is the reason why all "rbd map" attempts are failing?..
>
> As explained, "rbd map" attempts are failing because of RBD client
> instance sharing (or rather the way it's implemented in that "rbd map"
> doesn't check whether the existing instance is blocklisted).

yes, I can see it:
static struct rbd_device *__rbd_dev_create(struct rbd_client *rbdc,
struct rbd_spec *spec)
{
    struct rbd_device *rbd_dev;
...
     rbd_dev->rbd_client = rbdc; <<=== comes from rbd_get_client()

/*
* Get a ceph client with specific addr and configuration, if one does
* not exist create it. Either way, ceph_opts is consumed by this
* function.
*/
static struct rbd_client *rbd_get_client(struct ceph_options *ceph_opts)

That explains everything. Thank you!

>
> >
> > >
> > > >
> > > > We've done some brief analysis of the kernel side.
> > > >
> > > > Kernelside call stack:
> > > > sysfs_write [/sys/bus/rbd/add_single_major]
> > > > add_single_major_store
> > > > do_rbd_add
> > > > rbd_add_acquire_lock
> > > > rbd_acquire_lock
> > > > rbd_try_acquire_lock <- EBLOCKLISTED comes from there for 2nd and
> > > > further attempts
> > > >
> > > > Most probably the place at which it was interrupted by a signal:
> > > > static int rbd_add_acquire_lock(struct rbd_device *rbd_dev)
> > > > {
> > > > ...
> > > >
> > > >         rbd_assert(!rbd_is_lock_owner(rbd_dev));
> > > >         queue_delayed_work(rbd_dev->task_wq, &rbd_dev->lock_dwork, 0);
> > > >         ret = wait_for_completion_killable_timeout(&rbd_dev->acquire_wait,
> > > >         ceph_timeout_jiffies(rbd_dev->opts->lock_timeout)); <=== signal arrives
> > > >
> > > > As far as I understand, we had been receiving the EBLOCKLISTED errno
> > > > because ceph_monc_blocklist_add()
> > > > sent the "osd blocklist add" command to the ceph monitor successfully.
> > >
> > > RBD doesn't use ceph_monc_blocklist_add() to blocklist itself.  It's
> > > there to blocklist some _other_ RBD client that happens to be holding
> > > the lock and isn't responding to this RBD client's requests to release
> > > it.
> >
> > Got it. Thanks for clarifying this.
> >
> > >
> > > > We had removed the client from blocklist [2].
> > >
> > > This is very dangerous and generally shouldn't ever be done.
> > > Blocklisting is Ceph's term for fencing.  Manually lifting the fence
> > > without fully understanding what is going on in the system is a fast
> > > ticket to data corruption.
> > >
> > > I see that [2] does say "Doing this may put data integrity at risk" but
> > > not nearly as strong as it should.  Also, it's for CephFS, not RBD.
> > >
> > > > But we still weren't able to perform the rbd map. It looks like some
> > > > extra state is saved on the kernel client side and blocks us.
> > >
> > > By default, all RBD mappings on the node share the same "RBD client"
> > > instance.  Once it's blocklisted, all existing mappings mappings are
> > > affected.  Unfortunately, new mappings don't check for that and just
> > > attempt to reuse that instance as usual.
> > >
> > > This sharing can be disabled by passing "-o noshare" to "rbd map" but
> > > I would recommend cleaning up existing mappings instead.
> >
> > So, we need to execute (on a client node):
> > $ rbd showmapped
> > and then
> > $ rbd unmap ...
> > for each mapping, correct?
>
> More or less, but note that in case of a filesystem mounted on top of
> any of these mappings, you would need to unmount it first.

Of course!

>
> Thanks,
>
>                 Ilya

Thanks a lot for your help and explanations, Ilya!

Kind regards,
Alex

>
> >
> > >
> > > Thanks,
> > >
> > >                 Ilya
> > >
> > > >
> > > > What do you think about it?
> > > >
> > > > Links:
> > > > [1] https://github.com/lxc/lxd/pull/11213
> > > > [2] https://docs.ceph.com/en/quincy/cephfs/eviction/#advanced-un-blocklisting-a-client
> > > >
> > > > Kind regards,
> > > > Alex
