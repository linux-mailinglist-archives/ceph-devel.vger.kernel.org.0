Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A57E72E87A
	for <lists+ceph-devel@lfdr.de>; Tue, 13 Jun 2023 18:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236092AbjFMQ1h (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 13 Jun 2023 12:27:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233048AbjFMQ1g (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 13 Jun 2023 12:27:36 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28789E4
        for <ceph-devel@vger.kernel.org>; Tue, 13 Jun 2023 09:27:35 -0700 (PDT)
Received: from mail-yb1-f197.google.com (mail-yb1-f197.google.com [209.85.219.197])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id B9DB83F26D
        for <ceph-devel@vger.kernel.org>; Tue, 13 Jun 2023 16:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1686673652;
        bh=ValhE6UfwquXmpyVBBbxsSIHDSpMkwILF2ZvydAjNCo=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=Mv+QtKMfdN2J2sq830gLu0Wau+SFK5O9Q7TEJPfJs6iG/8rmCYBaatHuJ6zYpaOoF
         Wv9R9/SNRPt2mbLDZOzyfaCi8ZCBHosJJZOCfGayMqrw+j8omoVq6hDMmsWq7NwQLD
         bhYgYy4+js28X39S6xX6E95I4MoK8wYLYHA3lvEkWW/xp5+OFck8WCEo7j3uwqaPFZ
         bK4TtjcgcFiyldgLjgsp33mY5UDWpJ6VJbq3RjPVbu14HmffmQoFNQbuIIs9TzReiF
         RadPGU42GV71J0NYdF3uj3bhGjpi2DPvSW5i4/x6qhzfgIS7+HAfEBSEpotQ1OjGl5
         sD5duTbNlJc9w==
Received: by mail-yb1-f197.google.com with SMTP id 3f1490d57ef6-ba88ec544ddso8256764276.1
        for <ceph-devel@vger.kernel.org>; Tue, 13 Jun 2023 09:27:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686673650; x=1689265650;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ValhE6UfwquXmpyVBBbxsSIHDSpMkwILF2ZvydAjNCo=;
        b=idHU/zh2rF6ZR4/nBD302IDGYvd4XzJrwtk16MiEmTBGPSKpKSg/E2QpM+y7b0hmRK
         Dt6kxjMBNV5b6mq8g48uYjvzDmxmztqxeVwEn+5YhMtxXIA91V8orpXcw/FiOPZ7Lhjc
         jaSLOBlfaAZp3pncVzlcRid/7rf5+21tH0ac5r0hGSDK5T6+66aUIxtrXEXJqi7eMxVl
         qVU/7wIPUnZwT9c4cswT/EFrunOUPp3Oh8fXaBgVZcfbd4tTdWIeUK0RxHLLopul10PF
         W/QYYjI75zZNMinFL1DqfNJWRlLc2bP5UK1BZ+AWc5xoZHWgmU+7kwctnF5jmRCupOjS
         tWeA==
X-Gm-Message-State: AC+VfDwgCbubU7T2SIdvajf18uMI7tgbWq4R2VI8XYssO7H3uop+rguv
        bhIIynXU82ZqEo4LLQdHzS2y5IwrbS92chuk8RODtvUqCGr3rrKuQbzU3oPUEy/S9g5DxA6ZtEv
        PMW7NvLTWYH0gm7CGmL7bqUkAOynt+iYF2hciUdATRsoKOvUs4jCDIJM=
X-Received: by 2002:a25:4605:0:b0:bc6:6083:8f42 with SMTP id t5-20020a254605000000b00bc660838f42mr1564364yba.21.1686673649892;
        Tue, 13 Jun 2023 09:27:29 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5JlLRjmXwi2pYsePj7YxcsfdOk4CxL8axkWWI3zvYCCITZ+u0R3LM2ErXc9+TNwZ73jINAQkimPaDpZvWgJb8=
X-Received: by 2002:a25:4605:0:b0:bc6:6083:8f42 with SMTP id
 t5-20020a254605000000b00bc660838f42mr1564353yba.21.1686673649608; Tue, 13 Jun
 2023 09:27:29 -0700 (PDT)
MIME-Version: 1.0
References: <20230608154256.562906-1-aleksandr.mikhalitsyn@canonical.com>
 <f3864ed6-8c97-8a7a-f268-dab29eb2fb21@redhat.com> <CAEivzxcRsHveuW3nrPnSBK6_2-eT4XPvza3kN2oogvnbVXBKvQ@mail.gmail.com>
 <20230609-alufolie-gezaubert-f18ef17cda12@brauner> <CAEivzxc_LW6mTKjk46WivrisnnmVQs0UnRrh6p0KxhqyXrErBQ@mail.gmail.com>
 <ac1c6817-9838-fcf3-edc8-224ff85691e0@redhat.com> <CAJ4mKGby71qfb3gd696XH3AazeR0Qc_VGYupMznRH3Piky+VGA@mail.gmail.com>
In-Reply-To: <CAJ4mKGby71qfb3gd696XH3AazeR0Qc_VGYupMznRH3Piky+VGA@mail.gmail.com>
From:   Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Date:   Tue, 13 Jun 2023 18:27:18 +0200
Message-ID: <CAEivzxfdYagVp+nA1RXdtWa0XAM82TScLWSfYr6ZH5zAOGVcVQ@mail.gmail.com>
Subject: Re: [PATCH v5 00/14] ceph: support idmapped mounts
To:     Gregory Farnum <gfarnum@redhat.com>
Cc:     Xiubo Li <xiubli@redhat.com>,
        Christian Brauner <brauner@kernel.org>, stgraber@ubuntu.com,
        linux-fsdevel@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Jun 13, 2023 at 4:54=E2=80=AFPM Gregory Farnum <gfarnum@redhat.com>=
 wrote:
>
> On Mon, Jun 12, 2023 at 6:43=E2=80=AFPM Xiubo Li <xiubli@redhat.com> wrot=
e:
> >
> >
> > On 6/9/23 18:12, Aleksandr Mikhalitsyn wrote:
> > > On Fri, Jun 9, 2023 at 12:00=E2=80=AFPM Christian Brauner <brauner@ke=
rnel.org> wrote:
> > >> On Fri, Jun 09, 2023 at 10:59:19AM +0200, Aleksandr Mikhalitsyn wrot=
e:
> > >>> On Fri, Jun 9, 2023 at 3:57=E2=80=AFAM Xiubo Li <xiubli@redhat.com>=
 wrote:
> > >>>>
> > >>>> On 6/8/23 23:42, Alexander Mikhalitsyn wrote:
> > >>>>> Dear friends,
> > >>>>>
> > >>>>> This patchset was originally developed by Christian Brauner but I=
'll continue
> > >>>>> to push it forward. Christian allowed me to do that :)
> > >>>>>
> > >>>>> This feature is already actively used/tested with LXD/LXC project=
.
> > >>>>>
> > >>>>> Git tree (based on https://github.com/ceph/ceph-client.git master=
):
> > >>> Hi Xiubo!
> > >>>
> > >>>> Could you rebase these patches to 'testing' branch ?
> > >>> Will do in -v6.
> > >>>
> > >>>> And you still have missed several places, for example the followin=
g cases:
> > >>>>
> > >>>>
> > >>>>      1    269  fs/ceph/addr.c <<ceph_netfs_issue_op_inline>>
> > >>>>                req =3D ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_=
GETATTR,
> > >>>> mode);
> > >>> +
> > >>>
> > >>>>      2    389  fs/ceph/dir.c <<ceph_readdir>>
> > >>>>                req =3D ceph_mdsc_create_request(mdsc, op, USE_AUTH=
_MDS);
> > >>> +
> > >>>
> > >>>>      3    789  fs/ceph/dir.c <<ceph_lookup>>
> > >>>>                req =3D ceph_mdsc_create_request(mdsc, op, USE_ANY_=
MDS);
> > >>> We don't have an idmapping passed to lookup from the VFS layer. As =
I
> > >>> mentioned before, it's just impossible now.
> > >> ->lookup() doesn't deal with idmappings and really can't otherwise y=
ou
> > >> risk ending up with inode aliasing which is really not something you
> > >> want. IOW, you can't fill in inode->i_{g,u}id based on a mount's
> > >> idmapping as inode->i_{g,u}id absolutely needs to be a filesystem wi=
de
> > >> value. So better not even risk exposing the idmapping in there at al=
l.
> > > Thanks for adding, Christian!
> > >
> > > I agree, every time when we use an idmapping we need to be careful wi=
th
> > > what we map. AFAIU, inode->i_{g,u}id should be based on the filesyste=
m
> > > idmapping (not mount),
> > > but in this case, Xiubo want's current_fs{u,g}id to be mapped
> > > according to an idmapping.
> > > Anyway, it's impossible at now and IMHO, until we don't have any
> > > practical use case where
> > > UID/GID-based path restriction is used in combination with idmapped
> > > mounts it's not worth to
> > > make such big changes in the VFS layer.
> > >
> > > May be I'm not right, but it seems like UID/GID-based path restrictio=
n
> > > is not a widespread
> > > feature and I can hardly imagine it to be used with the container
> > > workloads (for instance),
> > > because it will require to always keep in sync MDS permissions
> > > configuration with the
> > > possible UID/GID ranges on the client. It looks like a nightmare for =
sysadmin.
> > > It is useful when cephfs is used as an external storage on the host, =
but if you
> > > share cephfs with a few containers with different user namespaces idm=
apping...
> >
> > Hmm, while this will break the MDS permission check in cephfs then in
> > lookup case. If we really couldn't support it we should make it to
> > escape the check anyway or some OPs may fail and won't work as expected=
.

Dear Gregory,

Thanks for the fast reply!

>
> I don't pretend to know the details of the VFS (or even our linux
> client implementation), but I'm confused that this is apparently so
> hard. It looks to me like we currently always fill in the "caller_uid"
> with "from_kuid(&init_user_ns, req->r_cred->fsuid))". Is this actually
> valid to begin with? If it is, why can't the uid mapping be applied on
> that?

Applying an idmapping is not hard, it's as simple as replacing
from_kuid(&init_user_ns, req->r_cred->fsuid)
to
from_vfsuid(req->r_mnt_idmap, &init_user_ns, VFSUIDT_INIT(req->r_cred->fsui=
d))

but the problem is that we don't have req->r_mnt_idmap for all the requests=
.
For instance, we don't have idmap arguments (that come from the VFS
layer) for ->lookup
operation and many others. There are some reasons for that (Christian
has covered some of them).
So, it's not about my laziness to implement that. It's a real pain ;-)

>
> As both the client and the server share authority over the inode's
> state (including things like mode bits and owners), and need to do
> permission checking, being able to tell the server the relevant actor
> is inherently necessary. We also let admins restrict keys to
> particular UID/GID combinations as they wish, and it's not the most
> popular feature but it does get deployed. I would really expect a user
> of UID mapping to be one of the *most* likely to employ such a
> facility...maybe not with containers, but certainly end-user homedirs
> and shared spaces.
>
> Disabling the MDS auth checks is really not an option. I guess we
> could require any user employing idmapping to not be uid-restricted,
> and set the anonymous UID (does that work, Xiubo, or was it the broken
> one? In which case we'd have to default to root?). But that seems a
> bit janky to me.

That's an interesting point about anonymous UID, but at the same time,
We use these caller's fs UID/GID values as an owner's UID/GID for
newly created inodes.
It means that we can't use anonymous UID everywhere in this case
otherwise all new files/directories
will be owned by an anonymous user.

> -Greg

Kind regards,
Alex

>
> > @Greg
> >
> > For the lookup requests the idmapping couldn't get the mapped UID/GID
> > just like all the other requests, which is needed by the MDS permission
> > check. Is that okay to make it disable the check for this case ? I am
> > afraid this will break the MDS permssions logic.
> >
> > Any idea ?
> >
> > Thanks
> >
> > - Xiubo
> >
> >
> > > Kind regards,
> > > Alex
> > >
> >
>
