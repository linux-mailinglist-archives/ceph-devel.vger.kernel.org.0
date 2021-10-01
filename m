Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E12641F1EF
	for <lists+ceph-devel@lfdr.de>; Fri,  1 Oct 2021 18:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354559AbhJAQPt (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 1 Oct 2021 12:15:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:54294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232020AbhJAQPt (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 1 Oct 2021 12:15:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A6EE61881;
        Fri,  1 Oct 2021 16:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633104844;
        bh=aqrGWxaGpOQLTIjFfvFbSKaLirprcdL5GMryGqzwt/M=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=G/xh25mrJen3/J1O7cMRc1Ji/8pJm2OzEB6Xy0gY0ORSQ4c6P3kw4aUxB5IxvAm+L
         ym7fh52VjHOwweS13B86hpCGsXfDOQrqLX3zCpIeCwL7rLFtUXSeb5xVvO2RrASUfy
         Uxvp936bBQtg0l4L177Relt1sw+eUMX4KcgrJagSJd5QJiRCkhcKjmNHPD8v4A4irV
         hp8g6+NEjDImUMUWR7MejowkK0044rh4+q2jei8F4qfQBK77MYUBnzF2ZYxuF9YsGP
         cAbgUrVWp660bQRbAtsl1WkvAuZQPKqRr3Z6W26HD44pfIzfxwQGh3NxG6+TqbgNWr
         2Ea2FzGddZNcA==
Message-ID: <8ee5ac3412f8ef58a61d33d178365b2daeb84598.camel@kernel.org>
Subject: Re: [PATCH v1] ceph: don't rely on error_string to validate
 blocklisted session.
From:   Jeff Layton <jlayton@kernel.org>
To:     Kotresh Hiremath Ravishankar <khiremat@redhat.com>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Venky Shankar <vshankar@redhat.com>,
        Xiubo Li <xiubli@redhat.com>, ceph-devel@vger.kernel.org
Date:   Fri, 01 Oct 2021 12:14:03 -0400
In-Reply-To: <CAPgWtC6Y_Bh5TeL_JN8KJ6ftKa=A=6aZmdNtj1Tb=OO_An+tpA@mail.gmail.com>
References: <20210927135227.290145-1-khiremat@redhat.com>
         <ac394a47a2a6bb7ee55a4fad3fdc279b73164196.camel@kernel.org>
         <CAPgWtC6Y_Bh5TeL_JN8KJ6ftKa=A=6aZmdNtj1Tb=OO_An+tpA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.4 (3.40.4-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2021-09-27 at 22:12 +0530, Kotresh Hiremath Ravishankar wrote:
> 
> 
> On Mon, Sep 27, 2021 at 9:45 PM Jeff Layton <jlayton@kernel.org>
> wrote:
> > 
> > On Mon, 2021-09-27 at 19:22 +0530, khiremat@redhat.com wrote:
> > > From: Kotresh HR <khiremat@redhat.com>
> > > 
> > 
> > This looks good. For future reference, I'd have probably marked this
> > as
> > [PATCH v2]. One minor style nit below, but you don't need to resend
> > for
> > that. I'll fix it up when I merge it if you're OK with it.
> 
> I did format it with [PATCH v2], not sure why 'git send-email' didn't
> pick it up.
> Sure, No problem. Thanks Jeff!
> 

Merged. Please take a look when you have time and let me know if you see
anything wrong with the final result.

Thanks,
Jeff
-- 
Jeff Layton <jlayton@kernel.org>

