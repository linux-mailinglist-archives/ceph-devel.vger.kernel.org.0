Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A43711D8E6E
	for <lists+ceph-devel@lfdr.de>; Tue, 19 May 2020 06:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726366AbgESEAn (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 19 May 2020 00:00:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbgESEAn (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 19 May 2020 00:00:43 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F39AEC061A0C;
        Mon, 18 May 2020 21:00:42 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id c20so9924282ilk.6;
        Mon, 18 May 2020 21:00:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YMISo78hL6Pp1LYoLknIURuBMh7SpGTi20rRpTAn94g=;
        b=B8esUJBa6fAkrFrLfM4cuWFkuP0LC1On+oDVYNt1UfHOSu+8+ucq7iH2Iw2DyT6bRJ
         aoby3Pok+cG0JUCh/fFekS+fompz5VivbO0VbAv7bnCLxsow4BmlwlrwJ83q0Tc1RFwg
         F0pZPDKiuMIvAUpulSYJA916RL8f+LPozWN7u1E/xsA1rFtKprPFY0gTlu0qRdQ1ccjh
         pp1mVvAP73KzNeDTSq3ktwVdegHNTbDIuBdRW1g3SOSGSMSDWMRlsKXqkHlhKXbdqUkR
         99YAre5ZwH2V5EZAs2Yu6rfrAh/ROGlDufH9JJ4zzofTwl99dDQAvfoeISPcfO53x2hS
         0dow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YMISo78hL6Pp1LYoLknIURuBMh7SpGTi20rRpTAn94g=;
        b=ENjsf2So1dcwE4gjbIwD/B69quP5nSOPy77vjNKj2LLKgLCGvl0lqYrnvlE5Xrlu4T
         JBSYDskJWEw1qjeqlAvTHikTF4nadzPTc1PwIi/5Z2zkTKqGH1VpVWOeRn2o610r+Z8m
         nb3Bzxk66WVtf1+CJKRoh6YVHO8hX23XSMFtyCChHfems2Yprii3OYiJXoVrLXHwFcE8
         U54SHeU+he5qmaGGKgu3tchsRAeCqvAXKTLPC+2hiXXELq1AtRFXqvmjlMflhLu8s6Sk
         vXy3mqThOhQiGfusl/j9STVgpmZR1kEHOf1vDDUxCHBGl+BwrRZL+05Q9gENchO72CKz
         FHNg==
X-Gm-Message-State: AOAM533lMS9ehTTfMrYfyZud8eTcKXXdn+JdvHtoTgi8y7tHalJwNtX6
        NDkmevFduwjqFjS6JnndQtJeeArCjGxF1NS/KuA=
X-Google-Smtp-Source: ABdhPJyQJgR5yTS4N+0JWiF2JGKG283HyP0dTsU4nr0LD+H9udNV7mju1EsjNpxFKEm1nXD/gLi9uncR2XtK80xJUGk=
X-Received: by 2002:a92:9e11:: with SMTP id q17mr20295545ili.137.1589860842312;
 Mon, 18 May 2020 21:00:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200514111453.GA99187@suse.com> <8497fe9a11ac1837813ee5f14b6ebae8fa6bf707.camel@kernel.org>
 <20200514124845.GA12559@suse.com> <4e5bf0e3bf055e53a342b19d168f6cf441781973.camel@kernel.org>
 <CAOQ4uxhireZBRvcPQzTS8yOoO4gQt78M0ktZo-9yQ-zcaLZbow@mail.gmail.com>
 <20200515111548.GA54598@suse.com> <61b1f19edcc349641b5383c2ac70cbf9a15ba4bd.camel@kernel.org>
 <CAOQ4uxiWZoSj3Pjwskd_hu-ErV9096hLt13CDcW6nEEvcwDNVA@mail.gmail.com>
 <e227d42fdc91587e34bc64ac252970d39d9b4eee.camel@kernel.org> <CAJ4mKGbahd8CbkEauBHBX6o93jipkCVoYe9O-1rAJQJFZkqDsQ@mail.gmail.com>
In-Reply-To: <CAJ4mKGbahd8CbkEauBHBX6o93jipkCVoYe9O-1rAJQJFZkqDsQ@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 19 May 2020 07:00:31 +0300
Message-ID: <CAOQ4uxjdu7=wXNBHZBQmtNexcG3qfu=XQov9HsRNi=os+QHAUg@mail.gmail.com>
Subject: Re: [PATCH] ceph: don't return -ESTALE if there's still an open file
To:     Gregory Farnum <gfarnum@redhat.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Luis Henriques <lhenriques@suse.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, May 19, 2020 at 1:30 AM Gregory Farnum <gfarnum@redhat.com> wrote:
>
> Maybe we resolved this conversation; I can't quite tell...

I think v2 patch wraps it up...

[...]

> > >
> > > Questions:
> > > 1. Does sync() result in fully purging inodes on MDS?
> >
> > I don't think so, but again, that code is not trivial to follow. I do
> > know that the MDS keeps around a "strays directory" which contains
> > unlinked inodes that are lazily cleaned up. My suspicion is that it's
> > satisfying lookups out of this cache as well.
> >
> > Which may be fine...the MDS is not required to be POSIX compliant after
> > all. Only the fs drivers are.
>
> I don't think this is quite that simple. Yes, the MDS is certainly
> giving back stray inodes in response to a lookup-by-ino request. But
> that's for a specific purpose: we need to be able to give back caps on
> unlinked-but-open files. For NFS specifically, I don't know what the
> rules are on NFS file handles and unlinked files, but the Ceph MDS
> won't know when files are closed everywhere, and it translates from
> NFS fh to Ceph inode using that lookup-by-ino functionality.
>

There is no protocol rule that NFS server MUST return ESTALE
for file handle of a deleted file, but there is a rule that it MAY return
ESTALE for deleted file. For example, on server restart and traditional
block filesystem, there is not much choice.

So returning ESTALE when file is deleted but opened on another ceph
client is definitely allowed by the protocol standard, the question is
whether changing the behavior will break any existing workloads...

> >
> > > 2. Is i_nlink synchronized among nodes on deferred delete?
> > > IWO, can inode come back from the dead on client if another node
> > > has linked it before i_nlink 0 was observed?
> >
> > No, that shouldn't happen. The caps mechanism should ensure that it
> > can't be observed by other clients until after the change.
> >
> > That said, Luis' current patch doesn't ensure we have the correct caps
> > to check the i_nlink. We may need to add that in before we can roll with
> > this.
> >
> > > 3. Can an NFS client be "migrated" from one ceph node to another
> > > with an open but unlinked file?
> > >
> >
> > No. Open files in ceph are generally per-client. You can't pass around a
> > fd (or equivalent).
>
> But the NFS file handles I think do work across clients, right?
>

Maybe they can, but that would be like NFS server restart, so
all bets are off w.r.t open but deleted files.

Thanks,
Amir.
