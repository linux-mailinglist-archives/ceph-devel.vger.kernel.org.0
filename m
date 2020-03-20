Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD26318D31D
	for <lists+ceph-devel@lfdr.de>; Fri, 20 Mar 2020 16:40:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727438AbgCTPka (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 20 Mar 2020 11:40:30 -0400
Received: from tragedy.dreamhost.com ([66.33.205.236]:50513 "EHLO
        tragedy.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726954AbgCTPka (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 20 Mar 2020 11:40:30 -0400
Received: from localhost (localhost [127.0.0.1])
        by tragedy.dreamhost.com (Postfix) with ESMTPS id 7F04F15F89F;
        Fri, 20 Mar 2020 08:40:28 -0700 (PDT)
Date:   Fri, 20 Mar 2020 15:40:26 +0000 (UTC)
From:   Sage Weil <sage@newdream.net>
X-X-Sender: sage@piezo.novalocal
To:     Jeff Layton <jlayton@redhat.com>
cc:     "dev@ceph.io" <dev@ceph.io>,
        Ceph Development <ceph-devel@vger.kernel.org>
Subject: Re: extend cephadm to do minimal client setup for kcephfs (and maybe
 krbd)?
In-Reply-To: <407b958e768145625d6c58a2c09392539bf07144.camel@redhat.com>
Message-ID: <alpine.DEB.2.21.2003201535340.21681@piezo.novalocal>
References: <833eb05d54ca8338843566a1fce9afee9283bdb2.camel@redhat.com>  <alpine.DEB.2.21.2003201502120.21681@piezo.novalocal> <407b958e768145625d6c58a2c09392539bf07144.camel@redhat.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-VR-STATUS: OK
X-VR-SCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedugedrudeguddgjeejucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuggftfghnshhusghstghrihgsvgdpffftgfetoffjqffuvfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepfffhvffujgfkfhgfgggtsehttdertddtredvnecuhfhrohhmpefurghgvgcuhggvihhluceoshgrghgvsehnvgifughrvggrmhdrnhgvtheqnecuffhomhgrihhnpehgihhthhhusgdrtghomhenucfkphepuddvjedrtddrtddrudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphdphhgvlhhopehlohgtrghlhhhoshhtpdhinhgvthepuddvjedrtddrtddruddprhgvthhurhhnqdhprghthhepufgrghgvucghvghilhcuoehsrghgvgesnhgvfigurhgvrghmrdhnvghtqedpmhgrihhlfhhrohhmpehsrghgvgesnhgvfigurhgvrghmrdhnvghtpdhnrhgtphhtthhopegtvghphhdquggvvhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 20 Mar 2020, Jeff Layton wrote:
> On Fri, 2020-03-20 at 15:04 +0000, Sage Weil wrote:
> > On Fri, 20 Mar 2020, Jeff Layton wrote:
> > > I've had this PR sitting around for a while:
> > > 
> > >     https://github.com/ceph/ceph/pull/31885
> > > 
> > > It's bitrotted a bit, and I'll clean that up soon, but after looking
> > > over cephadm, I wonder if it would make sense to also extend it to do
> > > these actions on machines that are just intended to be kcephfs or krbd
> > > clients.
> > 
> > If you could just adjust this PR to update doc/cephadm/client-setup.rst or 
> > similar instead, that would be great.  We plan to delete the ceph-deploy 
> > section of the docs entirely Real Soon Now.
> > 
> 
> Done. Still waiting on the doc render though to make sure it looks ok.

Thanks!

> > > We typically don't need to do a full-blown install on the clients, so
> > > being able to install just the minimum packages needed and do a minimal
> > > conf/keyring setup would be nice.
> > > 
> > > Does this make sense? I'll open a tracker if the principal cephadm devs
> > > are OK with it.
> > 
> > With cephadm, you can do this with
> > 
> >  # curl ....
> >  # sudo ./cephadm add-repo --release octopus
> >  # sudo ./cephadm install ceph-common
> > 
> > without having to think about which distro you're using.
> > 
> > Eventually we might want to teach cephadm how to manage the host-side 
> > packages on certain hosts so that it keeps ceph.conf and client package(s) 
> > up to date, but that needs some design thinking first... until then, 
> > having simple docs would be great!
> 
> I'm mostly interested in making it super easy to set up a new client
> machine to do a mount or krbd setup. Keeping it all updated would be
> bonus of course, but the initial setup is the real pain point I think.
> 
> For that, it would be really nice to be able to just run "cephadm
> client-setup" and have it do everything needed. Should we be looking to
> cephadm for that or is it sort of out of scope of that project since
> it's really geared toward managing the server-side cluster?

I think it has to remain multiple steps right now, since

1- the 'ceph config generate-minimal-conf' needs to be run somewhere where 
the CLI is working--so not on the client host.  and then written to 
/etc/ceph, so you need 

 mkdir -p /etc/ceph
 cat > /etc/ceph/ceph.conf ...

ditto for the keyring

2- cephadm has to be downloaded/installed, so there is the obligatory curl 
or install step

3- the only thing left is

  # sudo ./cephadm add-repo --release octopus
  # sudo ./cephadm install ceph-common

and i'm not sure that it is helpful to combine those.


What probably *would* make sense at some point is a command you run on a 
remote (ceph) host that's like

 ceph cephadm setup-client-host <hostname> [<ip>]

but that would require setup of an ssh key.  Or a script that 
interactively lets you authenticate and then performs all needed 
steps, similar to ssh-copy-id.  But that needs some more thought around 
how it should work.

sage
