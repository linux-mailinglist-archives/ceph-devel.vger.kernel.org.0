Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F18318D254
	for <lists+ceph-devel@lfdr.de>; Fri, 20 Mar 2020 16:04:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727069AbgCTPEa (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 20 Mar 2020 11:04:30 -0400
Received: from tragedy.dreamhost.com ([66.33.205.236]:39762 "EHLO
        tragedy.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbgCTPEa (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 20 Mar 2020 11:04:30 -0400
Received: from localhost (localhost [127.0.0.1])
        by tragedy.dreamhost.com (Postfix) with ESMTPS id 6EF6915F888;
        Fri, 20 Mar 2020 08:04:29 -0700 (PDT)
Date:   Fri, 20 Mar 2020 15:04:27 +0000 (UTC)
From:   Sage Weil <sage@newdream.net>
X-X-Sender: sage@piezo.novalocal
To:     Jeff Layton <jlayton@redhat.com>
cc:     "dev@ceph.io" <dev@ceph.io>,
        Ceph Development <ceph-devel@vger.kernel.org>
Subject: Re: extend cephadm to do minimal client setup for kcephfs (and maybe
 krbd)?
In-Reply-To: <833eb05d54ca8338843566a1fce9afee9283bdb2.camel@redhat.com>
Message-ID: <alpine.DEB.2.21.2003201502120.21681@piezo.novalocal>
References: <833eb05d54ca8338843566a1fce9afee9283bdb2.camel@redhat.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-VR-STATUS: OK
X-VR-SCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedugedrudeguddgieelucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuggftfghnshhusghstghrihgsvgdpffftgfetoffjqffuvfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepfffhvffujgfkfhgfgggtsehttdertddtredvnecuhfhrohhmpefurghgvgcuhggvihhluceoshgrghgvsehnvgifughrvggrmhdrnhgvtheqnecuffhomhgrihhnpehgihhthhhusgdrtghomhenucfkphepuddvjedrtddrtddrudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphdphhgvlhhopehlohgtrghlhhhoshhtpdhinhgvthepuddvjedrtddrtddruddprhgvthhurhhnqdhprghthhepufgrghgvucghvghilhcuoehsrghgvgesnhgvfigurhgvrghmrdhnvghtqedpmhgrihhlfhhrohhmpehsrghgvgesnhgvfigurhgvrghmrdhnvghtpdhnrhgtphhtthhopegtvghphhdquggvvhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 20 Mar 2020, Jeff Layton wrote:
> I've had this PR sitting around for a while:
> 
>     https://github.com/ceph/ceph/pull/31885
> 
> It's bitrotted a bit, and I'll clean that up soon, but after looking
> over cephadm, I wonder if it would make sense to also extend it to do
> these actions on machines that are just intended to be kcephfs or krbd
> clients.

If you could just adjust this PR to update doc/cephadm/client-setup.rst or 
similar instead, that would be great.  We plan to delete the ceph-deploy 
section of the docs entirely Real Soon Now.

> We typically don't need to do a full-blown install on the clients, so
> being able to install just the minimum packages needed and do a minimal
> conf/keyring setup would be nice.
> 
> Does this make sense? I'll open a tracker if the principal cephadm devs
> are OK with it.

With cephadm, you can do this with

 # curl ....
 # sudo ./cephadm add-repo --release octopus
 # sudo ./cephadm install ceph-common

without having to think about which distro you're using.

Eventually we might want to teach cephadm how to manage the host-side 
packages on certain hosts so that it keeps ceph.conf and client package(s) 
up to date, but that needs some design thinking first... until then, 
having simple docs would be great!

sage
