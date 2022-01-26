Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B05649C0B0
	for <lists+ceph-devel@lfdr.de>; Wed, 26 Jan 2022 02:22:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235792AbiAZBWY (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 25 Jan 2022 20:22:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235772AbiAZBWY (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 25 Jan 2022 20:22:24 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24AB8C06173B;
        Tue, 25 Jan 2022 17:22:24 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id w7so25929738ioj.5;
        Tue, 25 Jan 2022 17:22:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3sHzQsnog+/MeC+S+SFTQBzA5hA9X7thTZ4pLzJ9aDQ=;
        b=GHpeNQnXHJKAqzEILfnWBTGJxldRDz1xmv6OcOeiv/PrJjTW/vIwfQOPoQK4Q7YaBa
         XWqRoDa4gv/iQDh8WORmp1H2O+MTUBP0wMVllnMaA7JfnY+HWGwZRmxxwU84SZcHqZ/C
         XBnI38yhZFGwsUX/gHWcnO2YIo/EDYENKuXLCQgfDOP7NSlZojISEvGvtTr9mWnHMTl5
         LiSNqB+28r3zrpEn9BEYmlEP0zlfRwvzoxmcxCleJuD2qTsDuECyWLVSNm2vbsI8rDK5
         3pAF/ugUa4vB47zqooYfMz8ALgib0js7hr1xdIvmMmFBTmiZ3GqvSaphvLSuj5PuZ0F8
         O9rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3sHzQsnog+/MeC+S+SFTQBzA5hA9X7thTZ4pLzJ9aDQ=;
        b=JJ3GUT5zp3oxAGQuBAi/ujzCXvu+41QSwsTgysMi+9t+t8RVoqlmfHhPTfvmkO4tUt
         7nfJfEKrz9VgWJ9Kl8EuU78kGxrxOajdKbbJm6WPHN4ca3UfkAAdeHTYn40WfuBH12Ny
         p4br4pNlJIRqExBS3TEaALA33EOZ43309NDh5gk0BtBeF/NBUvqcTJKRqBrX8szAxZHG
         1+LgExJmrAc1QqIbV02iCiUI5j+/fMLAbmC3FxIUTebHbuyN4SibblGRh6tXbEerf4y0
         ntXIXdlRQtU92Ti1mQKr4qhQFgn7Pmqlmxim6vJ9LdpYz5L3/A2OcAxZtkrzlnq1+tx8
         vAxw==
X-Gm-Message-State: AOAM532lS+stFS6IxcruQN0C3hrw5P8DQj8Qrz3YvkqbyONlzzM2am7Y
        dvjVy5fW7Lg0G6YpWungXYZz94TtL4Mgyh86/Rc=
X-Google-Smtp-Source: ABdhPJy+/qVweXkT+q060i80puOgm9pFVPz/DGNiyZlNBjkFgtUOa1GRnJ76ahgOj2MvPndQXDxeWJphefemX78E4J8=
X-Received: by 2002:a02:b78d:: with SMTP id f13mr5243923jam.248.1643160143542;
 Tue, 25 Jan 2022 17:22:23 -0800 (PST)
MIME-Version: 1.0
References: <CAM2jsSiHK_++SggmRyRbCxZ58hywxeZsJJMJHpQfbAz-5AfJ0g@mail.gmail.com>
 <CAHC9VhR1efuTR_zLLhmOyS4EHT1oHgA1d_StooKXmFf9WGODyA@mail.gmail.com>
 <a77ca75bfb69f527272291b4e6556fc46c37f9df.camel@kernel.org>
 <20220125111350.t2jgmqdvshgr7doi@wittgenstein> <d5490a7c87b8c435b3c7bdb8d2c8edef2c2a576a.camel@kernel.org>
 <20220125121213.ontt4fide32phuzl@wittgenstein> <ab92b28e953601785467cdf8ca67dd5b0ef55105.camel@kernel.org>
 <YfAdtAaUfz38xtmf@redhat.com> <2f1c3741-df38-1179-5e3f-4cd1c4516e76@schaufler-ca.com>
 <CAHC9VhRgKZDzyNOhd-0nmKxBdnzQW5FHRwg9hHjGrUEPMhqaDg@mail.gmail.com> <YfCVesVeB0V++tok@redhat.com>
In-Reply-To: <YfCVesVeB0V++tok@redhat.com>
From:   Stephen Muth <smuth4@gmail.com>
Date:   Tue, 25 Jan 2022 20:22:12 -0500
Message-ID: <CAM2jsSij0QXuLgTprH7OQra1VqQKvTPNZ=Ouoe+OQG0=nx8zgg@mail.gmail.com>
Subject: Re: "kernel NULL pointer dereference" crash when attempting a write
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     Paul Moore <paul@paul-moore.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        ceph-devel@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        linux-security-module@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Jan 25, 2022 at 7:27 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Tue, Jan 25, 2022 at 02:57:46PM -0500, Paul Moore wrote:
> >
> > > > Looks like dentry_init_security() can't handle multiple LSMs. We probably
> > > > should disallow all other LSMs to register a hook for this and only
> > > > allow SELinux to register a hook.
> > >
> > > Not acceptable. The fix to dentry_init_security() is easy.
> >
> > Sounds good to me, Vivek did you want to put together a patch for
> > this?  If not, let me know and I'll put one together.
>
> Ok, I have put together this test patch. Stephen Muth, can you please
> test it and let us know if it solves your problem.
>
Just tested it, and had no problem making writes.
(Apologies for any double sends, accidentally had rich text enabled
the first time)
