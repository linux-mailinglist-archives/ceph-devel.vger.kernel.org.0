Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97A5A75799
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Jul 2019 21:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbfGYTKj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 25 Jul 2019 15:10:39 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:37662 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbfGYTKj (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 25 Jul 2019 15:10:39 -0400
Received: by mail-qk1-f194.google.com with SMTP id d15so37251874qkl.4
        for <ceph-devel@vger.kernel.org>; Thu, 25 Jul 2019 12:10:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7p7d7FgRsuD5lhWkNvAJjP73fhwUs4mqejHoWOUk/cQ=;
        b=fd70+KIVydjHSDKSZvBROWj+6kouFaRm1hJWmhv3mGyeA8iVrQJSyhQM+omqIxoXSx
         3Pz0cU1/bVDAu3yf5QMb7CXG7R2hTEkzlqD3JUfuXdbs24CcsRvxQxOFR4rfisx5AXBX
         RoWlA8WdT2QRTcM5agH/ozrAumqdULs7bhsXwrm3CDCNzbxY2Y8Mqp0N1+8szyOdAeOs
         Hd7uwDLNykLB6Z5eJc2HDdINZWe0TMzIrrGA+T8Y1LdDz2PbK4PvD/GoSgrbQ1eMK03v
         17CBbDiYzL0vtL9Zr/+U1OpwM0rjCi14FQUEC2rYbnyZKpEUPC+1aHrV/Vr+8a3KALzI
         6Msw==
X-Gm-Message-State: APjAAAV8BWFW4RBw1xvU5xDZxLPP3dN+U8KFLR/moHv81WxKbTJb41y9
        DdP9ZMSkUIQSi9DxNkPx8e46WgzSUoe6wjqBv1Arzw==
X-Google-Smtp-Source: APXvYqya6LrOrhYfUzt8Gx8jaxF4wM3AqOC3Yqj4cy1hf+duWkM1L3HKF8llMwjIZYJqSboiEJAdrHPOvX4ZfCMxzOM=
X-Received: by 2002:a05:620a:1648:: with SMTP id c8mr59022789qko.106.1564081837921;
 Thu, 25 Jul 2019 12:10:37 -0700 (PDT)
MIME-Version: 1.0
References: <20190724172026.23999-1-jlayton@kernel.org> <87ftmu4fq3.fsf@suse.com>
 <20190725115458.21e304c6@suse.com> <fd396da29b62b83559d7489757a3871b7453e7fa.camel@kernel.org>
 <20190725135854.66c3be3d@suse.de> <CA+2bHPbc86Kc9CSHj1PzZuEnY_8HLi1enAUjxTcNLuYREKvKmg@mail.gmail.com>
In-Reply-To: <CA+2bHPbc86Kc9CSHj1PzZuEnY_8HLi1enAUjxTcNLuYREKvKmg@mail.gmail.com>
From:   Gregory Farnum <gfarnum@redhat.com>
Date:   Thu, 25 Jul 2019 12:10:26 -0700
Message-ID: <CAJ4mKGb8CVOd55VTL6fpxGCJaHA6Eg2OZxUWQkXxaUOdsCNEMg@mail.gmail.com>
Subject: Re: [RFC PATCH] ceph: don't list vxattrs in listxattr()
To:     Patrick Donnelly <pdonnell@redhat.com>
Cc:     David Disseldorp <ddiss@suse.de>, Jeff Layton <jlayton@kernel.org>,
        Luis Henriques <lhenriques@suse.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Jul 25, 2019 at 12:04 PM Patrick Donnelly <pdonnell@redhat.com> wrote:
>
> On Thu, Jul 25, 2019 at 4:59 AM David Disseldorp <ddiss@suse.de> wrote:
> >
> > On Thu, 25 Jul 2019 07:17:11 -0400, Jeff Layton wrote:
> >
> > > Yeah, I rolled a half-assed xfstests patch that did this, and HCH gave
> > > it a NAK. He's probably right though, and fixing it in ceph.ko is a
> > > better approach I think.
> >
> > It sounds as though Christoph's objection is to any use of a "ceph"
> > xattr namespace for exposing CephFS specific information. I'm not sure
> > what the alternatives would be, but I find the vxattrs much nicer for
> > consumption compared to ioctls, etc.
>
> Agreed. I don't understand the objection [1] at all.
>
> If the issue is that utilities copying a file may also copy xattrs, I
> don't understand why there would be an expectation that all xattrs are
> copyable or should be copied.

I'm sure it is about this, and that's the expectation because, uh,
outside of weird things like Ceph then all matters are copyable and
should be copied. That's how the interface is defined and built.

I'm actually a bit puzzled to see this patch go by because I didn't
think we listed the ceph.* matters on a listxattr command! If we want
discoverability (to see what options are available on a running
system) we can return them in response to a getxattr on the "ceph"
xattr or something.
-Greg

>
> [1] https://www.spinics.net/lists/fstests/msg12282.html
>
> --
> Patrick Donnelly, Ph.D.
> He / Him / His
> Senior Software Engineer
> Red Hat Sunnyvale, CA
> GPG: 19F28A586F808C2402351B93C3301A3E258DD79D
