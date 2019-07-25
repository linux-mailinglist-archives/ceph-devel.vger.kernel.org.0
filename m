Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBE4275859
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Jul 2019 21:49:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726251AbfGYTtU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 25 Jul 2019 15:49:20 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:41498 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbfGYTtU (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 25 Jul 2019 15:49:20 -0400
Received: by mail-qt1-f193.google.com with SMTP id d17so50200093qtj.8
        for <ceph-devel@vger.kernel.org>; Thu, 25 Jul 2019 12:49:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OUrlY/DKI8KDNtFqmvRYgrlBPrsFd02uyV+HJTT3cjU=;
        b=h8pz/wd/aq2MJ25IO+oWwsRJKHDad0d7taSswOG0PN122Puksx42T9G7S6Cb3RwaUf
         2foRow/SDBV+BcTIxzkjzkGNxBwoG+9T5Hs/5LIZ0Y65wbQZ5iKKLTzi9plDSmkk3spp
         EdkONQOHzLnxdyqYS6rR2T5N4gxbExAxWczhmR3e5x+mRr3XuuV1EKrvN5C87kgt/0/k
         qU16Fni18+5sY3NIjZYHFUsnknPZlO0JMhAIVEJjoXUl6+Gz98m40ZJqXP5kOnEkEwdV
         uJLocPeODezWKjRNecdGLyB2Uzc/lvO5ZTLZcN26DbUUQblnHR747/izvllYlmYqsEHt
         tfGQ==
X-Gm-Message-State: APjAAAUtEiKDqtQvl5yTShZXQLUzTFFGxxcowEORT+1NUvh/apQOcqvt
        FsYxt2WwZTuEMDjKhE259QDU+zxQJnAEBmRJgfmsNw==
X-Google-Smtp-Source: APXvYqzcaRWtrweOdkByGoZqyeqCcEbjYoqsoqFAH+pjNT6ZWVfHfr7AxsqCLLmU78LMgV+hTsfwN57GxDi9c+5KEF8=
X-Received: by 2002:ad4:55a9:: with SMTP id f9mr64787833qvx.133.1564084159403;
 Thu, 25 Jul 2019 12:49:19 -0700 (PDT)
MIME-Version: 1.0
References: <20190724172026.23999-1-jlayton@kernel.org> <87ftmu4fq3.fsf@suse.com>
 <20190725115458.21e304c6@suse.com> <fd396da29b62b83559d7489757a3871b7453e7fa.camel@kernel.org>
 <20190725135854.66c3be3d@suse.de> <CA+2bHPbc86Kc9CSHj1PzZuEnY_8HLi1enAUjxTcNLuYREKvKmg@mail.gmail.com>
 <CAJ4mKGb8CVOd55VTL6fpxGCJaHA6Eg2OZxUWQkXxaUOdsCNEMg@mail.gmail.com>
In-Reply-To: <CAJ4mKGb8CVOd55VTL6fpxGCJaHA6Eg2OZxUWQkXxaUOdsCNEMg@mail.gmail.com>
From:   Patrick Donnelly <pdonnell@redhat.com>
Date:   Thu, 25 Jul 2019 12:48:53 -0700
Message-ID: <CA+2bHPYFXVPuiEt2UevYQq8YFNc6E4RbzLzyc6x4otnBWebgRQ@mail.gmail.com>
Subject: Re: [RFC PATCH] ceph: don't list vxattrs in listxattr()
To:     Gregory Farnum <gfarnum@redhat.com>
Cc:     David Disseldorp <ddiss@suse.de>, Jeff Layton <jlayton@kernel.org>,
        Luis Henriques <lhenriques@suse.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Jul 25, 2019 at 12:10 PM Gregory Farnum <gfarnum@redhat.com> wrote:
>
> On Thu, Jul 25, 2019 at 12:04 PM Patrick Donnelly <pdonnell@redhat.com> wrote:
> >
> > On Thu, Jul 25, 2019 at 4:59 AM David Disseldorp <ddiss@suse.de> wrote:
> > >
> > > On Thu, 25 Jul 2019 07:17:11 -0400, Jeff Layton wrote:
> > >
> > > > Yeah, I rolled a half-assed xfstests patch that did this, and HCH gave
> > > > it a NAK. He's probably right though, and fixing it in ceph.ko is a
> > > > better approach I think.
> > >
> > > It sounds as though Christoph's objection is to any use of a "ceph"
> > > xattr namespace for exposing CephFS specific information. I'm not sure
> > > what the alternatives would be, but I find the vxattrs much nicer for
> > > consumption compared to ioctls, etc.
> >
> > Agreed. I don't understand the objection [1] at all.
> >
> > If the issue is that utilities copying a file may also copy xattrs, I
> > don't understand why there would be an expectation that all xattrs are
> > copyable or should be copied.
>
> I'm sure it is about this, and that's the expectation because, uh,
> outside of weird things like Ceph then all matters are copyable and
> should be copied. That's how the interface is defined and built.

I don't really think anyone has defined what the interface really
should do. It's not even in POSIX (but apparently was in a draft). The
Linux documentation is silent on this matter AFAICT.

Until Linux gives us an acceptable mechanism (ioctl is not) to
expose/manipulate this information, we will continue to use xattrs.
(This patch annoys me but I'm okay with merging it.)

--
Patrick Donnelly, Ph.D.
He / Him / His
Senior Software Engineer
Red Hat Sunnyvale, CA
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D
