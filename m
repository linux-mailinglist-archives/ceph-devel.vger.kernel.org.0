Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16129753B5D
	for <lists+ceph-devel@lfdr.de>; Fri, 14 Jul 2023 14:57:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235738AbjGNM5c (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 14 Jul 2023 08:57:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235521AbjGNM5b (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 14 Jul 2023 08:57:31 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 765A92D41
        for <ceph-devel@vger.kernel.org>; Fri, 14 Jul 2023 05:57:29 -0700 (PDT)
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id AAB053F202
        for <ceph-devel@vger.kernel.org>; Fri, 14 Jul 2023 12:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1689339446;
        bh=RSNMrN8AQW1Yc/EsKcZ66WYJ77F+6TK2l6SGq5ZZEnU=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=IucuCnjHxH1elRBOVtFiKiYQ+OspScQBp5IOdhKzbWVKg+FqqBjjYQ9q74QSs1XL1
         oYz80ed7q8Ds4KuUFOtpIZH6mGKN+5aKHeZg3yiWazTGM0heC/rBVlEP5/cz4/BTyl
         17PTFbweS8K/C41FPTJu5UUYaUfru1bg0HC4isHqHZqKvhtg9xe99ez0Gx2v2oAAPp
         Mk5REv4SZ2MAfkjm9z0QuuRi/DuFCWJPTnZJg7RwrlQYHvEb/mbVVTLJVoiFBgMrEd
         i2BFC0A/kZizNUoxiW60QYvw0CU9FH3QoOe6bjGCBT7QQ6EiV5Aozcg+Pih2bhvV8I
         Q2OADuZSE1HFg==
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-3a1e58db5caso3331464b6e.0
        for <ceph-devel@vger.kernel.org>; Fri, 14 Jul 2023 05:57:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689339444; x=1691931444;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RSNMrN8AQW1Yc/EsKcZ66WYJ77F+6TK2l6SGq5ZZEnU=;
        b=Jcj/csrZB8iwb2I8TMTa0mPq+w7p2Rxiv8JVPHqDoEC/2fbePK1JE8M+ZVAa31T61M
         WyvJcEaUvOjuuXeF8XruVnPoaG4BpeSROmYBfxoEevJ6U33FBFgc6wEmURAfAFANSBab
         br7xwH3JmrABka3sQRei0Ldysb0Dst2qH/JS35jDl87oz6R5QbGj6/Y0PrODoeQWvvGW
         icdNYALru1GtdEDKXOGOQbnTPuYGRQcRwgUxX8IT6KkWHmd8o7jc/P7uKgILLuw2Z9oW
         wYpQ90V7JR6nMXUrjilvt1zdkQl5wyvkV5DtDyDNoDk10zSP9y94X+PHpWlWWA4wSq88
         /CEg==
X-Gm-Message-State: ABy/qLZKnkrjyR+9UVjQ/GIpeYeSuOs0bmLTE6dTtruaY/FP/5TiqETh
        7AZYP0ZmqF3hrin/8VL8wuIVGTYFOBFRyzXrAS58ei617jED7fdt7PANaAVodBjVUzaHVwKwUn3
        O2vub6qfhn+XrUOoz3Di9LLwAFKFg2GqC4Zq7izhR36JNr656csWgZS8=
X-Received: by 2002:a05:6358:e481:b0:135:57d0:d171 with SMTP id by1-20020a056358e48100b0013557d0d171mr4745224rwb.15.1689339444175;
        Fri, 14 Jul 2023 05:57:24 -0700 (PDT)
X-Google-Smtp-Source: APBJJlGPtv0QxF9hTo+qfW5UkQrEjCSG4SzGhFUlJTWtPlKt4q9ZrTRzsrd4mlj1Q/nMZBZI4/R7gT/cQTczMo9jkRM=
X-Received: by 2002:a05:6358:e481:b0:135:57d0:d171 with SMTP id
 by1-20020a056358e48100b0013557d0d171mr4745208rwb.15.1689339443819; Fri, 14
 Jul 2023 05:57:23 -0700 (PDT)
MIME-Version: 1.0
References: <20230608154256.562906-1-aleksandr.mikhalitsyn@canonical.com>
 <f3864ed6-8c97-8a7a-f268-dab29eb2fb21@redhat.com> <CAEivzxcRsHveuW3nrPnSBK6_2-eT4XPvza3kN2oogvnbVXBKvQ@mail.gmail.com>
 <20230609-alufolie-gezaubert-f18ef17cda12@brauner> <CAEivzxc_LW6mTKjk46WivrisnnmVQs0UnRrh6p0KxhqyXrErBQ@mail.gmail.com>
 <ac1c6817-9838-fcf3-edc8-224ff85691e0@redhat.com> <CAJ4mKGby71qfb3gd696XH3AazeR0Qc_VGYupMznRH3Piky+VGA@mail.gmail.com>
 <977d8133-a55f-0667-dc12-aa6fd7d8c3e4@redhat.com> <CAEivzxcr99sERxZX17rZ5jW9YSzAWYvAjOOhBH+FqRoso2=yng@mail.gmail.com>
 <626175e2-ee91-0f1a-9e5d-e506aea366fa@redhat.com> <64241ff0-9af3-6817-478f-c24a0b9de9b3@redhat.com>
 <CAEivzxeF51ZEKhQ-0M35nooZ7_cZgk1-q75-YbkeWpZ9RuHG4A@mail.gmail.com>
 <4c4f73d8-8238-6ab8-ae50-d83c1441ac05@redhat.com> <CAEivzxeQGkemxVwJ148b_+OmntUAWkdL==yMiTMN+GPyaLkFPg@mail.gmail.com>
 <0a42c5d0-0479-e60e-ac84-be3b915c62d9@redhat.com>
In-Reply-To: <0a42c5d0-0479-e60e-ac84-be3b915c62d9@redhat.com>
From:   Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Date:   Fri, 14 Jul 2023 14:57:12 +0200
Message-ID: <CAEivzxcskn8WxcOo0PDHMascFRdYTD0Lr5Uo4fj3deBjDviOXA@mail.gmail.com>
Subject: Re: [PATCH v5 00/14] ceph: support idmapped mounts
To:     Xiubo Li <xiubli@redhat.com>
Cc:     Gregory Farnum <gfarnum@redhat.com>,
        Christian Brauner <brauner@kernel.org>, stgraber@ubuntu.com,
        linux-fsdevel@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Jul 4, 2023 at 3:09=E2=80=AFAM Xiubo Li <xiubli@redhat.com> wrote:
>
> Sorry, not sure, why my last reply wasn't sent out.
>
> Do it again.
>
>
> On 6/26/23 19:23, Aleksandr Mikhalitsyn wrote:
> > On Mon, Jun 26, 2023 at 4:12=E2=80=AFAM Xiubo Li<xiubli@redhat.com>  wr=
ote:
> >> On 6/24/23 15:11, Aleksandr Mikhalitsyn wrote:
> >>> On Sat, Jun 24, 2023 at 3:37=E2=80=AFAM Xiubo Li<xiubli@redhat.com>  =
wrote:
> >>>> [...]
> >>>>
> >>>>    > > >
> >>>>    > > > I thought about this too and came to the same conclusion, t=
hat
> >>>> UID/GID
> >>>>    > > > based
> >>>>    > > > restriction can be applied dynamically, so detecting it on =
mount-time
> >>>>    > > > helps not so much.
> >>>>    > > >
> >>>>    > > For this you please raise one PR to ceph first to support thi=
s, and in
> >>>>    > > the PR we can discuss more for the MDS auth caps. And after t=
he PR
> >>>>    > > getting merged then in this patch series you need to check th=
e
> >>>>    > > corresponding option or flag to determine whether could the i=
dmap
> >>>>    > > mounting succeed.
> >>>>    >
> >>>>    > I'm sorry but I don't understand what we want to support here. =
Do we
> >>>> want to
> >>>>    > add some new ceph request that allows to check if UID/GID-based
> >>>>    > permissions are applied for
> >>>>    > a particular ceph client user?
> >>>>
> >>>> IMO we should prevent user to set UID/GID-based permisions caps from
> >>>> ceph side.
> >>>>
> >>>> As I know currently there is no way to prevent users to set MDS auth
> >>>> caps, IMO in ceph side at least we need one flag or option to disabl=
e
> >>>> this once users want this fs cluster sever for idmap mounts use case=
.
> >>> How this should be visible from the user side? We introducing a new
> >>> kernel client mount option,
> >>> like "nomdscaps", then pass flag to the MDS and MDS should check that
> >>> MDS auth permissions
> >>> are not applied (on the mount time) and prevent them from being
> >>> applied later while session is active. Like that?
> >>>
> >>> At the same time I'm thinking about protocol extension that adds 2
> >>> additional fields for UID/GID. This will allow to correctly
> >>> handle everything. I wanted to avoid any changes to the protocol or
> >>> server-side things. But if we want to change MDS side,
> >>> maybe it's better then to go this way?
> > Hi Xiubo,
> >
> >> There is another way:
> >>
> >> For each client it will have a dedicated client auth caps, something l=
ike:
> >>
> >> client.foo
> >>     key: *key*
> >>     caps: [mds] allow r, allow rw path=3D/bar
> >>     caps: [mon] allow r
> >>     caps: [osd] allow rw tag cephfs data=3Dcephfs_a
> > Do we have any infrastructure to get this caps list on the client side
> > right now?
> > (I've taken a quick look through the code and can't find anything
> > related to this.)
>
> I am afraid there is no.
>
> But just after the following ceph PR gets merged it will be easy to do th=
is:
>
> https://github.com/ceph/ceph/pull/48027
>
> This is still under testing.
>
> >> When mounting this client with idmap enabled, then we can just check t=
he
> >> above [mds] caps, if there has any UID/GID based permissions set, then
> >> fail the mounting.
> > understood
> >
> >> That means this kind client couldn't be mounted with idmap enabled.
> >>
> >> Also we need to make sure that once there is a mount with idmap enable=
d,
> >> the corresponding client caps couldn't be append the UID/GID based
> >> permissions. This need a patch in ceph anyway IMO.
> > So, yeah we will need to effectively block cephx permission changes if
> > there is a client mounted with
> > an active idmapped mount. Sounds as something that require massive
> > changes on the server side.
>
> Maybe no need much, it should be simple IMO. But I am not 100% sure.
>
> > At the same time this will just block users from using idmapped mounts
> > along with UID/GID restrictions.
> >
> > If you want me to change server-side anyways, isn't it better just to
> > extend cephfs protocol to properly
> > handle UID/GIDs with idmapped mounts? (It was originally proposed by Ch=
ristian.)
> > What we need to do here is to add a separate UID/GID fields for ceph
> > requests those are creating a new inodes
> > (like mknod, symlink, etc).

Dear Xiubo,

I'm sorry for delay with reply, I've missed this message accidentally.

>
> BTW, could you explain it more ? How could this resolve the issue we are
> discussing here ?

This was briefly mentioned here
https://lore.kernel.org/all/20220105141023.vrrbfhti5apdvkz7@wittgenstein/#t
by Christian. Let me describe it in detail.

In the current approach we apply mount idmapping to
head->caller_{uid,gid} fields
to make mkdir/mknod/symlink operations set a proper inode owner
uid/gid in according with an idmapping.

This makes a problem with path-based UID/GID restriction mechanism,
because it uses head->caller_{uid,gid} fields
to check if UID/GID is permitted or not.

So, the problem is that we have one field in ceph request for two
different needs - to control permissions and to set inode owner.
Christian pointed that the most saner way is to modify ceph protocol
and add a separate field to store inode owner UID/GID,
and only this fields should be idmapped, but head->caller_{uid,gid}
will be untouched.

With this approach, we will not affect UID/GID-based permission rules
with an idmapped mounts at all.

Kind regards,
Alex

>
> Thanks
>
> - Xiubo
>
>
> >
> > Kind regards,
> > Alex
> >
> >> Thanks
> >>
> >> - Xiubo
> >>
> >>
> >>
> >>
> >>
> >>> Thanks,
> >>> Alex
> >>>
> >>>> Thanks
> >>>>
> >>>> - Xiubo
> >>>>
>
