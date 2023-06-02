Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 518EC7202EB
	for <lists+ceph-devel@lfdr.de>; Fri,  2 Jun 2023 15:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235328AbjFBNQE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 2 Jun 2023 09:16:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235843AbjFBNQA (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 2 Jun 2023 09:16:00 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 480B5E64
        for <ceph-devel@vger.kernel.org>; Fri,  2 Jun 2023 06:15:41 -0700 (PDT)
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com [209.85.128.197])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 0190A3F555
        for <ceph-devel@vger.kernel.org>; Fri,  2 Jun 2023 13:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1685711726;
        bh=u076fhLtJeSydB1XIua93PO8nclzPCMG3IiM+N6xDS8=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=Z9xqXiBlDcEJPzR2/9hJk32G0ZP4MTWCHWGIE/pLtV4/yecHzSO6ymPvqjNDRKWka
         hWeJd0584oFjtwsE8dmTulo8Czlsy3JbDPlSSm5MKxCF14MuBAkzmFgdcXE3rNGZ3S
         iHUGoW4fUqJF0ng/Fh7xHbXrpnT3+PRFdt8GUuFU72suyyC/lQn3x5pOkCXa4iUZ2o
         2gYhcNTIA4Yiwd/sQBBKaZ1DO+gRcYgEPlTLdJpbr9eNwQJu80bLX6Vwt9jBp1iJK9
         FFPUbNvn0Eh5qLA79103C7nDFckw+kgfYmO6S4uKMxVPYYOTpJd3L0s3gMMeGqD/dR
         PZkBirlqlK7Tg==
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-5693861875fso22240007b3.1
        for <ceph-devel@vger.kernel.org>; Fri, 02 Jun 2023 06:15:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685711723; x=1688303723;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u076fhLtJeSydB1XIua93PO8nclzPCMG3IiM+N6xDS8=;
        b=ID2grjF6JDQX4uWSSXb/uXpHsxr8C8wrFkNCMXt8/hl1FWzx5iX219Du/djMG0kDJ3
         kQkIWwPLW/SsQ2EuUGFw9idwXdqct9fdRn6PwM7Y1oIqcHiJ+bcpE2AeMPqvgYe+b6Gf
         XP+XOopfaVqwJjxnCwrEA6DxTXUsG707IHbJoqHhOaN5wOeYFa8h6RKI+re3yjrzwhPG
         mxDQj/BUGQR78oRJh+3Ylc8QPx05BioyoIqlxnC7hwviQWlDv4ORNLeYnm/5MN3KcJy+
         Rgr30naixerxsC5izkFfxr7Ur131Tgw1ftTe/OqYKI7n/XJsISfXCdR4Y9CNiayRdLMu
         tsFQ==
X-Gm-Message-State: AC+VfDwUwlaIYhwkN7Ou2n7P98hHAMN4wpNVCf7H2dYx04pGfVb5V8LJ
        Zx/q7nP5txHPDXC/+ngzeYoguUl4f20ylTsqEOLtbg62UErDx4K8cE62P5N1t97IZSgye43Y18h
        7AecFkhTXBQ1arrnIEgQqpPVqvZ4gxN3BgGPQRW/w+Qz79iapOu6hK8bJU+R9L6EVPg==
X-Received: by 2002:a0d:cb45:0:b0:556:c778:9d60 with SMTP id n66-20020a0dcb45000000b00556c7789d60mr12955455ywd.43.1685711723666;
        Fri, 02 Jun 2023 06:15:23 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7oZ/NVBPuMJSPOzTFYcxMNqX02acJ4tHzsSIhKQcaPHczl7hdPQkv16vSee4HRNWpEn0VuAGnCxbSkIY+f9fU=
X-Received: by 2002:a0d:cb45:0:b0:556:c778:9d60 with SMTP id
 n66-20020a0dcb45000000b00556c7789d60mr12955426ywd.43.1685711723387; Fri, 02
 Jun 2023 06:15:23 -0700 (PDT)
MIME-Version: 1.0
References: <20230524153316.476973-1-aleksandr.mikhalitsyn@canonical.com>
 <20230524153316.476973-11-aleksandr.mikhalitsyn@canonical.com>
 <b3b1b8dc-9903-c4ff-0a63-9a31a311ff0b@redhat.com> <CAEivzxfxug8kb7_SzJGvEZMcYwGM8uW25gKa_osFqUCpF_+Lhg@mail.gmail.com>
 <20230602-vorzeichen-praktikum-f17931692301@brauner> <CAEivzxcwTbOUrT2ha8fR=wy-bU1+ZppapnMsqVXBXAc+C0gwhw@mail.gmail.com>
 <20230602-behoben-tauglich-b6ecd903f2a9@brauner>
In-Reply-To: <20230602-behoben-tauglich-b6ecd903f2a9@brauner>
From:   Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Date:   Fri, 2 Jun 2023 15:15:12 +0200
Message-ID: <CAEivzxfOgiQjXob+J1S5MsBFJjDGX_hApD_xR1s7q-S9eQh_bw@mail.gmail.com>
Subject: Re: [PATCH v2 10/13] ceph: allow idmapped setattr inode op
To:     Christian Brauner <brauner@kernel.org>
Cc:     Xiubo Li <xiubli@redhat.com>, stgraber@ubuntu.com,
        linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Jun 2, 2023 at 3:08=E2=80=AFPM Christian Brauner <brauner@kernel.or=
g> wrote:
>
> On Fri, Jun 02, 2023 at 03:05:50PM +0200, Aleksandr Mikhalitsyn wrote:
> > On Fri, Jun 2, 2023 at 2:54=E2=80=AFPM Christian Brauner <brauner@kerne=
l.org> wrote:
> > >
> > > On Fri, Jun 02, 2023 at 02:45:30PM +0200, Aleksandr Mikhalitsyn wrote=
:
> > > > On Fri, Jun 2, 2023 at 3:30=E2=80=AFAM Xiubo Li <xiubli@redhat.com>=
 wrote:
> > > > >
> > > > >
> > > > > On 5/24/23 23:33, Alexander Mikhalitsyn wrote:
> > > > > > From: Christian Brauner <christian.brauner@ubuntu.com>
> > > > > >
> > > > > > Enable __ceph_setattr() to handle idmapped mounts. This is just=
 a matter
> > > > > > of passing down the mount's idmapping.
> > > > > >
> > > > > > Cc: Jeff Layton <jlayton@kernel.org>
> > > > > > Cc: Ilya Dryomov <idryomov@gmail.com>
> > > > > > Cc: ceph-devel@vger.kernel.org
> > > > > > Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
> > > > > > Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@can=
onical.com>
> > > > > > ---
> > > > > >   fs/ceph/inode.c | 11 +++++++++--
> > > > > >   1 file changed, 9 insertions(+), 2 deletions(-)
> > > > > >
> > > > > > diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> > > > > > index 37e1cbfc7c89..f1f934439be0 100644
> > > > > > --- a/fs/ceph/inode.c
> > > > > > +++ b/fs/ceph/inode.c
> > > > > > @@ -2050,6 +2050,13 @@ int __ceph_setattr(struct inode *inode, =
struct iattr *attr)
> > > > > >
> > > > > >       dout("setattr %p issued %s\n", inode, ceph_cap_string(iss=
ued));
> > > > > >
> > > > > > +     /*
> > > > > > +      * The attr->ia_{g,u}id members contain the target {g,u}i=
d we're
> > >
> > > This is now obsolete... In earlier imlementations attr->ia_{g,u}id wa=
s
> > > used and contained the filesystem wide value, not the idmapped mount
> > > value.
> > >
> > > However, this was misleading and we changed that in commit b27c82e129=
65
> > > ("attr: port attribute changes to new types") and introduced dedicate=
d
> > > new types into struct iattr->ia_vfs{g,u}id. So the you need to use
> > > attr->ia_vfs{g,u}id as documented in include/linux/fs.h and you need =
to
> > > transform them into filesystem wide values and then to raw values you
> > > send over the wire.
> > >
> > > Alex should be able to figure this out though.
> >
> > Hi Christian,
> >
> > Thanks for pointing this out. Unfortunately I wasn't able to notice
> > that. I'll take a look closer and fix that.
>
> Just to clarify: I wasn't trying to imply that you should've figured
> this out on your own. I was just trying to say that you should be able
> figure out the exact details how to implement this in ceph after I told
> you about the attr->ia_vfs{g,u}id change.

No problem, I've got your idea the same as you explained it ;-)
I'll rework that place and I will recheck that we pass xfstests after that.
