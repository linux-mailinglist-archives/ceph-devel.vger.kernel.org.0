Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90C8C49B5A6
	for <lists+ceph-devel@lfdr.de>; Tue, 25 Jan 2022 15:05:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1577838AbiAYOEv (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 25 Jan 2022 09:04:51 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:54454 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379452AbiAYN7k (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 25 Jan 2022 08:59:40 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E14F7614DD
        for <ceph-devel@vger.kernel.org>; Tue, 25 Jan 2022 13:59:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D9C3C340E0;
        Tue, 25 Jan 2022 13:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643119178;
        bh=N8jSiIGyeGVV0QSDOFY7MxX+pUYsgkWCAAc2gSVnHk0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=djZfhqnU7QIw/6Txwrylt1oISDS9X08ZDxI91LOFPNQFcejMbp4fzO3l7hjRPFKc2
         No5wzZvG8CFkEiC/+0C4RQMuFl4s0+vX7G+qoWVZdQ88eesD76z1Q4HDK0pWAEXXQQ
         JkSJIikv7OEcBaj4lcicagwKLT4lZe3awrHW2E6ZLiDen1fhFlt8q8m9nLcuM3UfS7
         8ycAS5bHyA7VQY+cD/HrCGFFMuBKiKm3+tc8J9TqGPiFaKEUzrdDx5OcoIdUmPqyFS
         btStOMgK3LznXlpGh8QVWEXjMJ/BOyo9Grp+06QLFlLB2K/Weo6tQS31GGQpO01eEJ
         0fPkZcEPT1DZA==
Date:   Tue, 25 Jan 2022 14:59:33 +0100
From:   Christian Brauner <brauner@kernel.org>
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     Jeff Layton <jlayton@kernel.org>, Paul Moore <paul@paul-moore.com>,
        Stephen Muth <smuth4@gmail.com>, ceph-devel@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: Re: "kernel NULL pointer dereference" crash when attempting a write
Message-ID: <20220125135933.cefxoxa4hbe55y5u@wittgenstein>
References: <CAM2jsSiHK_++SggmRyRbCxZ58hywxeZsJJMJHpQfbAz-5AfJ0g@mail.gmail.com>
 <CAHC9VhR1efuTR_zLLhmOyS4EHT1oHgA1d_StooKXmFf9WGODyA@mail.gmail.com>
 <a77ca75bfb69f527272291b4e6556fc46c37f9df.camel@kernel.org>
 <YfABEFlldUTHL+BH@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YfABEFlldUTHL+BH@redhat.com>
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Jan 25, 2022 at 08:54:24AM -0500, Vivek Goyal wrote:
> On Tue, Jan 25, 2022 at 05:54:57AM -0500, Jeff Layton wrote:
> 
> [..]
> > -	/*
> > -	 * FIXME: Make security_dentry_init_security() generic. Currently
> > -	 * It only supports single security module and only selinux has
> > -	 * dentry_init_security hook.
> > -	 */
> 
> I think this comment is still very valid. security_dentry_init_security()
> still supports only single security module. It does not have the
> capability to deal with two modules trying to return security context.
> 
> All my patch did was that instead of SELinux, now another LSM could
> return security context and also return xattr name for the security
> context. But it did nothing to allow multiple LSMs to return their
> own security contexts.

Yeah, that still doesn't work.
Your patch did however help uncover what is a but in the current
security_dentry_init_security() implementation afaict. Ceph was on the
safe side so far because it always initialized name unconditionally
because it knew that only selinux was relevant for this.
