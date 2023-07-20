Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BFD575A6C1
	for <lists+ceph-devel@lfdr.de>; Thu, 20 Jul 2023 08:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231393AbjGTGnS (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 20 Jul 2023 02:43:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231552AbjGTGnF (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 20 Jul 2023 02:43:05 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC07A3A9A
        for <ceph-devel@vger.kernel.org>; Wed, 19 Jul 2023 23:42:28 -0700 (PDT)
Received: from mail-yb1-f198.google.com (mail-yb1-f198.google.com [209.85.219.198])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 696C03F171
        for <ceph-devel@vger.kernel.org>; Thu, 20 Jul 2023 06:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1689835291;
        bh=sn08qCBGn2XFGLFjGE9p3/8YTfeVApEFDQBv99Etk1U=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=tMoOhAa6QqZj91bnl+GEtlJmQf1A+jRKASFX3SNbuusX0h9LhViBvPXSFegYf6m0B
         +Fr5aNpEsGbr96KbN2bI7I//GQgdrt4246A6zMpmBF1x+W8zZcAwvlIwoE/+vDGJpR
         FbJQ7NL8gkX7hRaAGSxnHRKXgdyZzk9GWqJVtTUUynJs8K/nRxWOrZ9gSTekpliMBu
         nUh3RnN0y/nukTMau1yNrrDufM8SeGWeOv0UFl+5Ta1Hi2WZ6P0qRInGEH/sgckgHZ
         MCAgmQMbL7Sa4devAbxahIj+tFzJBCSoDmDJ83zat7ZuWH2Z/H7HL+vBu+eOSidj5j
         cVoOptUyIn3FQ==
Received: by mail-yb1-f198.google.com with SMTP id 3f1490d57ef6-c647150c254so933256276.1
        for <ceph-devel@vger.kernel.org>; Wed, 19 Jul 2023 23:41:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689835288; x=1690440088;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sn08qCBGn2XFGLFjGE9p3/8YTfeVApEFDQBv99Etk1U=;
        b=hw3LRwa3bScS8ax58Z4rYJIhVoxuXNSKCXJEkD+59MumizEyKHDphmfB0vqcq48qjw
         OSza7UcH/A/4xh0sn+pM3hwCnGPOoSmp1NgNLzGvt5rP+5pFSdIPgZ9cTXAGphV0WZgi
         VqO0i0Fson4FtkiGV3F2Wg1QnEMvItki+nKY5j+VlXX/A9mWKhYQdgwHnftabM0BMLu0
         jEASpVfZEOag4rs9THThiZYE6xe0G5kwaOntsY+JMcUsIJOOs2ivQyikAdB/EwA2DTKd
         jcnlgaDNgGgXCWo6hd5aIc+9jHZko9D1Rm+m9ciXaCFuFcb4crKcQHe7ICoDHN5gYGH2
         S/Bg==
X-Gm-Message-State: ABy/qLZSWX/y8KTjIbWR04LBn7EkjoHaVbRokdahAeL9VzThrKNZiYxc
        EpuV3sbGZW4kEVvW2bGYFUcsSpFzhjOgTE2fSjca2Pm8Ura1VsamyeujY6GjAPZgDUZ4sBesdra
        umMvjKWyGucR24HYA9Jxefud3AaJ11CUTGYhkrX3gzAdPIpes2JFJxrU=
X-Received: by 2002:a25:9249:0:b0:cb4:6167:a69c with SMTP id e9-20020a259249000000b00cb46167a69cmr5112131ybo.8.1689835288069;
        Wed, 19 Jul 2023 23:41:28 -0700 (PDT)
X-Google-Smtp-Source: APBJJlHRUHni5nA4TPodPsFhdrPUcOi3Auu/AQXNen2dsyJArtRIYZfFvI/MbH0+WMcrgsUUn484rk/zGxs0vb3MmZY=
X-Received: by 2002:a25:9249:0:b0:cb4:6167:a69c with SMTP id
 e9-20020a259249000000b00cb46167a69cmr5112124ybo.8.1689835287796; Wed, 19 Jul
 2023 23:41:27 -0700 (PDT)
MIME-Version: 1.0
References: <20230608154256.562906-1-aleksandr.mikhalitsyn@canonical.com>
 <CAEivzxc_LW6mTKjk46WivrisnnmVQs0UnRrh6p0KxhqyXrErBQ@mail.gmail.com>
 <ac1c6817-9838-fcf3-edc8-224ff85691e0@redhat.com> <CAJ4mKGby71qfb3gd696XH3AazeR0Qc_VGYupMznRH3Piky+VGA@mail.gmail.com>
 <977d8133-a55f-0667-dc12-aa6fd7d8c3e4@redhat.com> <CAEivzxcr99sERxZX17rZ5jW9YSzAWYvAjOOhBH+FqRoso2=yng@mail.gmail.com>
 <626175e2-ee91-0f1a-9e5d-e506aea366fa@redhat.com> <64241ff0-9af3-6817-478f-c24a0b9de9b3@redhat.com>
 <CAEivzxeF51ZEKhQ-0M35nooZ7_cZgk1-q75-YbkeWpZ9RuHG4A@mail.gmail.com>
 <4c4f73d8-8238-6ab8-ae50-d83c1441ac05@redhat.com> <CAEivzxeQGkemxVwJ148b_+OmntUAWkdL==yMiTMN+GPyaLkFPg@mail.gmail.com>
 <0a42c5d0-0479-e60e-ac84-be3b915c62d9@redhat.com> <CAEivzxcskn8WxcOo0PDHMascFRdYTD0Lr5Uo4fj3deBjDviOXA@mail.gmail.com>
 <8121882a-0823-3a60-e108-0ff7bae5c0c9@redhat.com> <CAEivzxcaJQvYyutAL8xapvoer06c97uVSVC729pUE=4_z4m_CA@mail.gmail.com>
 <CAEivzxfw1fHO2TFA4dx3u23ZKK6Q+EThfzuibrhA3RKM=ZOYLg@mail.gmail.com> <3af4f092-8de7-d217-cd2d-d39dfc625edd@redhat.com>
In-Reply-To: <3af4f092-8de7-d217-cd2d-d39dfc625edd@redhat.com>
From:   Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Date:   Thu, 20 Jul 2023 08:41:16 +0200
Message-ID: <CAEivzxcipdTQ9-b2zk-7-AMDfwPk2Brtp=X6H8xXsHMEtQJKFQ@mail.gmail.com>
Subject: Re: [PATCH v5 00/14] ceph: support idmapped mounts
To:     Xiubo Li <xiubli@redhat.com>
Cc:     Gregory Farnum <gfarnum@redhat.com>,
        Christian Brauner <brauner@kernel.org>, stgraber@ubuntu.com,
        linux-fsdevel@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Jul 20, 2023 at 8:36=E2=80=AFAM Xiubo Li <xiubli@redhat.com> wrote:
>
>
> On 7/19/23 19:57, Aleksandr Mikhalitsyn wrote:
> > On Tue, Jul 18, 2023 at 4:49=E2=80=AFPM Aleksandr Mikhalitsyn
> > <aleksandr.mikhalitsyn@canonical.com> wrote:
> >> On Tue, Jul 18, 2023 at 3:45=E2=80=AFAM Xiubo Li <xiubli@redhat.com> w=
rote:
> [...]
> >> No, the idea is to stop mapping a caller_{uid, gid}. And to add a new
> >> fields like
> >> inode_owner_{uid, gid} which will be idmapped (this field will be spec=
ific only
> >> for those operations that create a new inode).
> > I've decided to write some summary of different approaches and
> > elaborate tricky places.
> >
> > Current implementation.
> >
> > We have head->caller_{uid,gid} fields mapped in according
> > to the mount's idmapping. But as we don't have information about
> > mount's idmapping in all call stacks (like ->lookup case), we
> > are not able to map it always and they are left untouched in these case=
s.
> >
> > This tends to an inconsistency between different inode_operations,
> > for example ->lookup (don't have an access to an idmapping) and
> > ->mkdir (have an idmapping as an argument).
> >
> > This inconsistency is absolutely harmless if the user does not
> > use UID/GID-based restrictions. Because in this use case head->caller_{=
uid,gid}
> > fields used *only* to set inode owner UID/GID during the inode_operatio=
ns
> > which create inodes.
> >
> > Conclusion 1. head->caller_{uid,gid} fields have two meanings
> > - UID/GID-based permission checks
> > - inode owner information
> >
> > Solution 0. Ignore the issue with UID/GID-based restrictions and idmapp=
ed mounts
> > until we are not blamed by users ;-)
> >
> > As far as I can see you are not happy about this way. :-)
> >
> > Solution 1. Let's add mount's idmapping argument to all inode_operation=
s
> > and always map head->caller_{uid,gid} fields.
> >
> > Not a best idea, because:
> > - big modification of VFS layer
> > - ideologically incorrect, for instance ->lookup should not care
> > and know *anything* about mount's idmapping, because ->lookup works
> > not on the mount level (it's not important who and through which mount
> > triggered the ->lookup). Imagine that you've dentry cache filled and ca=
ll
> > open(...) in this case ->lookup can be uncalled. But if the user was no=
t lucky
> > enough to have cache filled then open(..) will trigger the lookup and
> > then ->lookup results will be dependent on the mount's idmapping. It
> > seems incorrect
> > and unobvious consequence of introducing such a parameter to ->lookup o=
peration.
> > To summarize, ->lookup is about filling dentry cache and dentry cache
> > is superblock-level
> > thing, not mount-level.
> >
> > Solution 2. Add some kind of extra checks to ceph-client and ceph
> > server to detect that
> > mount idmappings used with UID/GID-based restrictions and restrict such=
 mounts.
> >
> > Seems not ideal to me too. Because it's not a fix, it's a limitation
> > and this limitation is
> > not cheap from the implementation perspective (we need heavy changes
> > in ceph server side and
> > client side too). Btw, currently VFS API is also not ready for that,
> > because we can't
> > decide if idmapped mounts are allowed or not in runtime. It's a static
> > thing that should be declared
> > with FS_ALLOW_IDMAP flag in (struct file_system_type)->fs_flags. Not a
> > big deal, but...
> >
> > Solution 3. Add a new UID/GID fields to ceph request structure in
> > addition to head->caller_{uid,gid}
> > to store information about inode owners (only for inode_operations
> > which create inodes).
> >
> > How does it solves the problem?
> > With these new fields we can leave head->caller_{uid,gid} untouched
> > with an idmapped mounts code.
> > It means that UID/GID-based restrictions will continue to work as inten=
ded.
> >
> > At the same time, new fields (let say "inode_owner_{uid,gid}") will be
> > mapped in accordance with
> > a mount's idmapping.
> >
> > This solution seems ideal, because it is philosophically correct, it
> > makes cephfs idmapped mounts to work
> > in the same manner and way as idmapped mounts work for any other
> > filesystem like ext4.
>
> Okay, this approach sounds more reasonable to me. But you need to do
> some extra work to make it to be compatible between {old,new} kernels
> and  {old,new} cephs.

Sure. Then I'll start implementing this.

Kind regards,
Alex

>
> So then the caller uid/gid will always be the user uid/gid issuing the
> requests as now.
>
> Thanks
>
> - Xiubo
>
>
> > But yes, this requires cephfs protocol changes...
> >
> > I personally still believe that the "Solution 0" approach is optimal
> > and we can go with "Solution 3" way
> > as the next iteration.
> >
> > Kind regards,
> > Alex
> >
> >> And also the same for other non-create requests. If
> >>> so this will be incorrect for the cephx perm checks IMO.
> >> Thanks,
> >> Alex
> >>
> >>> Thanks
> >>>
> >>> - Xiubo
> >>>
> >>>
> >>>> This makes a problem with path-based UID/GID restriction mechanism,
> >>>> because it uses head->caller_{uid,gid} fields
> >>>> to check if UID/GID is permitted or not.
> >>>>
> >>>> So, the problem is that we have one field in ceph request for two
> >>>> different needs - to control permissions and to set inode owner.
> >>>> Christian pointed that the most saner way is to modify ceph protocol
> >>>> and add a separate field to store inode owner UID/GID,
> >>>> and only this fields should be idmapped, but head->caller_{uid,gid}
> >>>> will be untouched.
> >>>>
> >>>> With this approach, we will not affect UID/GID-based permission rule=
s
> >>>> with an idmapped mounts at all.
> >>>>
> >>>> Kind regards,
> >>>> Alex
> >>>>
> >>>>> Thanks
> >>>>>
> >>>>> - Xiubo
> >>>>>
> >>>>>
> >>>>>> Kind regards,
> >>>>>> Alex
> >>>>>>
> >>>>>>> Thanks
> >>>>>>>
> >>>>>>> - Xiubo
> >>>>>>>
> >>>>>>>
> >>>>>>>
> >>>>>>>
> >>>>>>>
> >>>>>>>> Thanks,
> >>>>>>>> Alex
> >>>>>>>>
> >>>>>>>>> Thanks
> >>>>>>>>>
> >>>>>>>>> - Xiubo
> >>>>>>>>>
>
