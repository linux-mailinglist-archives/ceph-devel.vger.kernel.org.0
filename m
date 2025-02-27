Return-Path: <ceph-devel+bounces-2830-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BA92EA47CBE
	for <lists+ceph-devel@lfdr.de>; Thu, 27 Feb 2025 12:59:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B537E3AD1E6
	for <lists+ceph-devel@lfdr.de>; Thu, 27 Feb 2025 11:59:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2A1A22A1D1;
	Thu, 27 Feb 2025 11:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lvtWaTlS"
X-Original-To: ceph-devel@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DF6B226888;
	Thu, 27 Feb 2025 11:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740657588; cv=none; b=ZFHFMC44BCy4huvg+2WUPUyvY3H4HQ85PBbtLkMN2YrH1D6SchQ8yTtjr87ICeyGfTS+C5nQTzEB1n1pGwEUpO8hSEihfn7g5MUgOZxehDi/Jgcrgdsycj1IjjgML3S+HGG7TMe93MJIesY4jjqTVEr968QfQUcS2ModMKyX8xE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740657588; c=relaxed/simple;
	bh=9xkorSWqbHCcT017DovA/DsygjJD3ow9OL2+y2kGr6w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Sp1mpl65/zJqbYKld9vvdz9jUTKrTpK+SAmwh8KvxnM947KaezNwAxkOtX02QaTpHw6ZX0svsLsMDdTNTuuyV+ADvDZOSPENueTfb7LGvxV555s6cNvGNjcw5z2gYOPTYzZulWD3FXDIRx3s/gbMF8o4W8TaC301/KqbTOaDRIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lvtWaTlS; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D85A0C4CEDD;
	Thu, 27 Feb 2025 11:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740657588;
	bh=9xkorSWqbHCcT017DovA/DsygjJD3ow9OL2+y2kGr6w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lvtWaTlSmqfymPV4D1wgovMYcvMo2zK86hIunMyjf2jY5PHuhKRCRVYMfcRHuWTEd
	 +9Je28jImvyUE1KK7DiIBt1oqFwFeni7vse8nZpDsHSWjxLkEU+M4psOkunwgJvZxp
	 ghMY2QWpvN5vhbkEbw8OlROkU+FndL/z10Gl2i1BAUMRSfcdnwaKKwVKFCLV8EZC6J
	 i2NcQdE2lEfG2wIfgolWHfZexiZkaQ+vgRHs/N7YU6I7vAufSRc+IE5iYm2BQheEup
	 vBs/3sjF/zpcVI2Z8+30S/QbVZRknuIRC6TlTzk2GhgUo6RtoEYZ8GF2rDW8noaeTD
	 IJNQR/FEqzxBw==
Date: Thu, 27 Feb 2025 12:59:43 +0100
From: Christian Brauner <brauner@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>, 
	Viacheslav Dubeyko <slava@dubeyko.com>, ceph-devel@vger.kernel.org, amarkuze@redhat.com, 
	idryomov@gmail.com, linux-fsdevel@vger.kernel.org, pdonnell@redhat.com, 
	Slava.Dubeyko@ibm.com
Subject: Re: Can you take ceph patches and ceph mm changes into the VFS tree?
Message-ID: <20250227-halbsatz-halbzeit-b9f6be29c21c@brauner>
References: <3148604.1740657480@warthog.procyon.org.uk>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3148604.1740657480@warthog.procyon.org.uk>

On Thu, Feb 27, 2025 at 11:58:00AM +0000, David Howells wrote:
> Hi Christian,
> 
> Unless the ceph people would prefer to take them through the ceph tree, can
> you consider taking the following fixes:
> 
>     https://lore.kernel.org/r/20250205000249.123054-1-slava@dubeyko.com/
> 
> into the VFS tree and adding:
> 
>     https://lore.kernel.org/r/20250217185119.430193-1-willy@infradead.org/
> 
> on top of that.  Willy's patches are for the next merge window, but are
> rebased on top of Viacheslav's patches.
> 
> I have the patches here also:
> 
>     https://web.git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log/?h=ceph-folio

Sure! Thanks! I'll wait until tomorrow so people have time to reply.

