Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DD2B33534
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Jun 2019 18:45:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727191AbfFCQp3 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 3 Jun 2019 12:45:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53702 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725974AbfFCQp3 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 3 Jun 2019 12:45:29 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 392CC7EBBD;
        Mon,  3 Jun 2019 16:45:29 +0000 (UTC)
Received: from ovpn-112-65.rdu2.redhat.com (ovpn-112-65.rdu2.redhat.com [10.10.112.65])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AE9BF61983;
        Mon,  3 Jun 2019 16:45:28 +0000 (UTC)
Date:   Mon, 3 Jun 2019 16:45:27 +0000 (UTC)
From:   Sage Weil <sweil@redhat.com>
X-X-Sender: sage@piezo.novalocal
To:     Ilya Dryomov <idryomov@gmail.com>
cc:     Ceph Development <ceph-devel@vger.kernel.org>
Subject: Re: ANNOUNCE: moving the ceph-devel list to ceph.io
In-Reply-To: <CAOi1vP8kUzBGw2L2XqdOhTM41zeyVxxHutHbSnhr4BG53aN-hQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1906031641210.22596@piezo.novalocal>
References: <alpine.DEB.2.11.1906022104460.3107@piezo.novalocal> <CAOi1vP8kUzBGw2L2XqdOhTM41zeyVxxHutHbSnhr4BG53aN-hQ@mail.gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Mon, 03 Jun 2019 16:45:29 +0000 (UTC)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 3 Jun 2019, Ilya Dryomov wrote:
> On Mon, Jun 3, 2019 at 4:34 PM Sage Weil <sweil@redhat.com> wrote:
> > Why are we doing this?
> >
> > 1 The new list is mailman and managed by the Ceph community, which means
> >   that when people have problems with subscribe, mails being lost, or any
> >   other list-related problems, we can actually do something about it.
> >   Currently we have no real ability to perform any management-related tasks
> >   on the vger list.
> >
> > 2 The vger majordomo software also has some frustrating
> >   features/limitations, the most notable being that it only accepts
> >   plaintext email; anything with MIME or HTML formatting is rejected.  This
> >   confuses many users.
> >
> > 3 The kernel development and general Ceph development have slightly
> >   different modes of collaboration.  Kernel code review is based on email
> >   patches to the list and reviewing via email, which can be noisy and
> >   verbose for those not involved in kernel development.  The Ceph userspace
> >   code is handled via github pull requests, which capture both proposed
> >   changes and code review.
> 
> I agree on all three points, although at least my recollection is that
> we have had a lot of bouncing issues with ceph-users and no issues with
> ceph-devel besides the plain text-only policy which some might argue is
> actually a good thing ;)
> 
> However it seems that two mailing lists with identical names might
> bring new confusion, particularly when searching through past threads.
> Was a different name considered for the new list?

Sigh... we didn't discuss another name, and the confusion with 
searching archives in particular didn't occur to me.  :(  If we're going 
to use a different name, now is the time to pick one.

I'm not sure what is better than ceph-devel, though...

Maybe making a new ceph-kernel@vger.kernel.org and aliasing the old 
ceph-devel to either ceph-kernel or the (new) ceph-devel would be the 
least confusing end state?

sage
