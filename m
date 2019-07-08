Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AC32620DB
	for <lists+ceph-devel@lfdr.de>; Mon,  8 Jul 2019 16:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731985AbfGHOuI (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 8 Jul 2019 10:50:08 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:45337 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725905AbfGHOuI (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 8 Jul 2019 10:50:08 -0400
Received: by mail-ed1-f66.google.com with SMTP id e2so8066555edi.12;
        Mon, 08 Jul 2019 07:50:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=xqD9//vj8hyLQhGtAn7OCQx4sQ5rQOlHZCIXpnadci0=;
        b=rOrXFx3Bc/hwiJvEdJNsKrbM90PbzvbN/E+5fM3JYFUlefRprxepT8ORwFRGfjH6g5
         SwECpUtBnUTYXiQYYW3FwXa4FciqgA70AdhmrVxZPqAC2kPrnENv5dkLpXbBuR+3tyk7
         ZvtGejI3nsLP/XQZIuo/2LXKPsojhJ6aV1szipsFm0AQ8kDj8aDn1dAFvvbSq6bP3mYi
         dBoY66MpsAhDIPuus8AXUyVG9vYjdVrv7F06zNhCu+msD4JJtBfiNkfqSqhLJgSnmMnd
         Umpc7BI3ziNyAOP510ujmqpcY5fJCCPFn3T9HPzwsXETGHMwSaXn/G39GhZj+oXmTsGQ
         vuCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=xqD9//vj8hyLQhGtAn7OCQx4sQ5rQOlHZCIXpnadci0=;
        b=dJnz8bO8F7KSgQKNs8Q9E9Hf1arpre3KcUpb0Q6cVdf+zQUd+Qs1pZSuunPOHj4h3R
         z8hnaS+2ldlnaIePpqr6zaD2SCEcOVY2oG7/ZpVx1DzWwrAzKL9r0puxmxk9YdFiYpvH
         +VbHNKYohs3hw1+OhKcTJYXjl+xaxYRGZzcbMTmwNsPHCLKODU/BawnzXYgJyMqvaNeH
         fnq6Z0jjDnwwWAqvuuJysvZ8WBQejvFuHfzbVYMTaWtP+YrQaCoHTcZ4EjeMKcMGLBuZ
         3QM8ADFj/B+pSXffNxDRJ0Ngp2hjtVFbxHNskIU0d2CflQWBKlUAuXyI8MdFjerowJ2t
         m0KQ==
X-Gm-Message-State: APjAAAU5aY8luGtY8tNHi3EudnHR9WgSQBGIKSRMO5xIKYiqH6GqF30e
        TyBIQXApez76WtEN3SXkUMg=
X-Google-Smtp-Source: APXvYqxt23CLo9IIkHXCkj0qvqdL4T6+9V8SwBfp/4gULMA6Th4DnExR1aYs+mQefTg1e9PwHQh4yQ==
X-Received: by 2002:a17:906:310c:: with SMTP id 12mr16489797ejx.259.1562597406063;
        Mon, 08 Jul 2019 07:50:06 -0700 (PDT)
Received: from archlinux-epyc ([2a01:4f9:2b:2b15::2])
        by smtp.gmail.com with ESMTPSA id 43sm5668607edz.87.2019.07.08.07.50.04
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 07:50:05 -0700 (PDT)
Date:   Mon, 8 Jul 2019 07:50:03 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     "Yan, Zheng" <zyan@redhat.com>, Sage Weil <sage@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@kernel.org>,
        Luis Henriques <lhenriques@suse.com>,
        ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH] ceph: fix uninitialized return code
Message-ID: <20190708145003.GB43693@archlinux-epyc>
References: <20190708134821.587398-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190708134821.587398-1-arnd@arndb.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Jul 08, 2019 at 03:48:08PM +0200, Arnd Bergmann wrote:
> clang points out a -Wsometimed-uninitized bug in the modified
> ceph_real_mount() function:
> 
> fs/ceph/super.c:850:6: error: variable 'err' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
>         if (!fsc->sb->s_root) {
>             ^~~~~~~~~~~~~~~~
> fs/ceph/super.c:885:9: note: uninitialized use occurs here
>         return err;
>                ^~~
> fs/ceph/super.c:850:2: note: remove the 'if' if its condition is always true
>         if (!fsc->sb->s_root) {
>         ^~~~~~~~~~~~~~~~~~~~~~
> fs/ceph/super.c:843:9: note: initialize the variable 'err' to silence this warning
>         int err;
>                ^
>                 = 0
> 
> Set it to zero if the condition is false.
> 
> Fixes: 108f95bfaa56 ("vfs: Convert ceph to use the new mount API")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Thanks for the patch!

Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
