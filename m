Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E59CED4B78
	for <lists+ceph-devel@lfdr.de>; Sat, 12 Oct 2019 02:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbfJLAq7 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 11 Oct 2019 20:46:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:55414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726345AbfJLAq7 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 11 Oct 2019 20:46:59 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 782862089F;
        Sat, 12 Oct 2019 00:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570841217;
        bh=9PlEvpymwObzdTDffCNuGMQl1lSMz06hvXhH2alMCMg=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=vHG+sjgPWJngRS5lemgQmPY1SZUS1eqQSB9/eGl2o3D05vXTjMK+jS/lTD3pitCXa
         BQigYqsar+nzb0SBIMPX3fi23YZBcOYWxC1e9/IQP9wUYNTOTNRVm20xGwOi60IiRP
         Rsjn6J4e8aNjw0cWIY7kAWeqL7S/3Kz+PvkN6zNU=
Message-ID: <e9890c9feabe863dacf702327fd219f3a76fac57.camel@kernel.org>
Subject: Re: Hung CephFS client
From:   Jeff Layton <jlayton@kernel.org>
To:     Robert LeBlanc <robert@leblancnet.us>,
        ceph-devel <ceph-devel@vger.kernel.org>
Date:   Fri, 11 Oct 2019 20:46:56 -0400
In-Reply-To: <CAANLjFpQuOjeGkD_+0LNTeLystCKJ6WqA7A3X4vNgu8n+L8KWw@mail.gmail.com>
References: <CAANLjFpQuOjeGkD_+0LNTeLystCKJ6WqA7A3X4vNgu8n+L8KWw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2019-10-11 at 15:55 -0700, Robert LeBlanc wrote:
> We had a docker container that seems to be hung in the CephFS code
> path. We were able to extract the following:
> 
>            <...>-77292 [003] 1175858.326638: function:
> _raw_spin_lock
> 
>            <...>-77292 [003] 1175858.326640: function:             __wake_up
> 
>            <...>-77292 [003] 1175858.326641: function:
> _raw_spin_lock_irqsave
> 
>            <...>-77292 [003] 1175858.326641: function:
> __wake_up_common
> 
>            <...>-77292 [003] 1175858.326641: function:
> _raw_spin_unlock_irqrestore
> 
>            <...>-77292 [003] 1175858.326641: function:             __wake_up
> 
>            <...>-77292 [003] 1175858.326641: function:
> _raw_spin_lock_irqsave
> 
>            <...>-77292 [003] 1175858.326641: function:
> __wake_up_common
> 
>            <...>-77292 [003] 1175858.326641: function:
>   autoremove_wake_function
> 
>            <...>-77292 [003] 1175858.326641: function:
>      default_wake_function
> 
>            <...>-77292 [003] 1175858.326641: function:
>         try_to_wake_up
> 
>            <...>-77292 [003] 1175858.326642: function:
>            _raw_spin_lock_irqsave
> 
>            <...>-77292 [003] 1175858.326642: function:
>            task_waking_fair
> 
>            <...>-77292 [003] 1175858.326642: function:
>            select_task_rq_fair
> 
>            <...>-77292 [003] 1175858.326642: function:
>               source_load
> 
>            <...>-77292 [003] 1175858.326643: function:
>               target_load
> 
>            <...>-77292 [003] 1175858.326643: function:
>               effective_load.isra.45
> 
>            <...>-77292 [003] 1175858.326644: function:
>               effective_load.isra.45
> 
>            <...>-77292 [003] 1175858.326644: function:
>               select_idle_sibling
> 
>            <...>-77292 [003] 1175858.326645: function:
>                  idle_cpu
> 
>            <...>-77292 [003] 1175858.326645: function:
>            set_nr_if_polling
> 
>            <...>-77292 [003] 1175858.326645: function:
>            ttwu_stat
> 
>            <...>-77292 [003] 1175858.326646: function:
>            _raw_spin_unlock_irqrestore
> 
>            <...>-77292 [003] 1175858.326646: function:
> _raw_spin_unlock_irqrestore
> 
>            <...>-77292 [003] 1175858.326646: function:             irq_exit
> 
>            <...>-77292 [003] 1175858.326646: function:
> _raw_spin_unlock
> 
>            <...>-77292 [003] 1175858.326646: function:
> try_get_cap_refs
> 
>            <...>-77292 [003] 1175858.326647: function:
> _raw_spin_lock
> 
>            <...>-77292 [003] 1175858.326647: function:
> __ceph_caps_file_wanted
> 
>            <...>-77292 [003] 1175858.326647: function:
>   ceph_caps_for_mode
> 
>            <...>-77292 [003] 1175858.326647: function:
> __ceph_caps_issued
> 
>            <...>-77292 [003] 1175858.326647: function:
> _raw_spin_unlock
> 
>            <...>-77292 [003] 1175858.326647: function:             _cond_resched
> 
>            <...>-77292 [003] 1175858.326647: function:
> try_get_cap_refs
> 
>            <...>-77292 [003] 1175858.326647: function:
> _raw_spin_lock
> 
>            <...>-77292 [003] 1175858.326647: function:
> __ceph_caps_file_wanted
> 
>            <...>-77292 [003] 1175858.326647: function:
>   ceph_caps_for_mode
> 
>            <...>-77292 [003] 1175858.326647: function:
> __ceph_caps_issued
> 
>            <...>-77292 [003] 1175858.326647: function:
> _raw_spin_unlock
> 
>            <...>-77292 [003] 1175858.326647: function:
> prepare_to_wait_event
> 
>            <...>-77292 [003] 1175858.326647: function:
> try_get_cap_refs
> 
>            <...>-77292 [003] 1175858.326647: function:
> _raw_spin_lock
> 
>            <...>-77292 [003] 1175858.326647: function:
> __ceph_caps_file_wanted
> 
>            <...>-77292 [003] 1175858.326647: function:
>   ceph_caps_for_mode
> 
>            <...>-77292 [003] 1175858.326648: function:
> __ceph_caps_issued
> 
>            <...>-77292 [003] 1175858.326648: function:
> _raw_spin_unlock
> 
>            <...>-77292 [003] 1175858.326648: function:             finish_wait
> 
>            <...>-77292 [003] 1175858.326648: function:             ceph_get_caps
> 
>            <...>-77292 [003] 1175858.326648: function:
> ceph_pool_perm_check
> 
>            <...>-77292 [003] 1175858.326648: function:
>   _raw_spin_lock
> 
>            <...>-77292 [003] 1175858.326648: function:
>   _raw_spin_unlock
> 
>            <...>-77292 [003] 1175858.326648: function:
> try_get_cap_refs
> 
>            <...>-77292 [003] 1175858.326648: function:
>   _raw_spin_lock
> 
>            <...>-77292 [003] 1175858.326648: function:
>   __ceph_caps_file_wanted
> 
>            <...>-77292 [003] 1175858.326648: function:
>      ceph_caps_for_mode
> 
>            <...>-77292 [003] 1175858.326648: function:
>   __ceph_caps_issued
> 
>            <...>-77292 [003] 1175858.326648: function:
>   _raw_spin_unlock
> 
>            <...>-77292 [003] 1175858.326648: function:
> _cond_resched
> 
>            <...>-77292 [003] 1175858.326648: function:
> try_get_cap_refs
> 
>            <...>-77292 [003] 1175858.326648: function:
>   _raw_spin_lock
> 
>            <...>-77292 [003] 1175858.326649: function:
>   __ceph_caps_file_wanted
> 
>            <...>-77292 [003] 1175858.326649: function:
>      ceph_caps_for_mode
> 
>            <...>-77292 [003] 1175858.326649: function:
>   __ceph_caps_issued
> 
>            <...>-77292 [003] 1175858.326649: function:
>   _raw_spin_unlock
> 
>            <...>-77292 [003] 1175858.326649: function:
> prepare_to_wait_event
> 
>            <...>-77292 [003] 1175858.326649: function:
> try_get_cap_refs
> 
>            <...>-77292 [003] 1175858.326649: function:
>   _raw_spin_lock
> 
>            <...>-77292 [003] 1175858.326649: function:
>   __ceph_caps_file_wanted
> 
>            <...>-77292 [003] 1175858.326649: function:
>      ceph_caps_for_mode
> 
>            <...>-77292 [003] 1175858.326649: function:
>   __ceph_caps_issued
> 
>            <...>-77292 [003] 1175858.326649: function:
>   _raw_spin_unlock
> 
>            <...>-77292 [003] 1175858.326649: function:
> finish_wait
> 
>            <...>-77292 [003] 1175858.326649: function:             ceph_get_caps
> 
>            <...>-77292 [003] 1175858.326649: function:
> ceph_pool_perm_check
> 
>            <...>-77292 [003] 1175858.326649: function:
>   _raw_spin_lock
> 
>            <...>-77292 [003] 1175858.326649: function:
>   _raw_spin_unlock
> 
>            <...>-77292 [003] 1175858.326649: function:
> try_get_cap_refs
> 
>            <...>-77292 [003] 1175858.326649: function:
>   _raw_spin_lock
> 
>            <...>-77292 [003] 1175858.326649: function:
>   __ceph_caps_file_wanted
> 
>            <...>-77292 [003] 1175858.326650: function:
>      ceph_caps_for_mode
> 
>            <...>-77292 [003] 1175858.326650: function:
>   __ceph_caps_issued
> 
>            <...>-77292 [003] 1175858.326650: function:
>   _raw_spin_unlock
> 
>            <...>-77292 [003] 1175858.326650: function:
> _cond_resched
> 
>            <...>-77292 [003] 1175858.326650: function:
> try_get_cap_refs
> 
>            <...>-77292 [003] 1175858.326650: function:
>   _raw_spin_lock
> 
>            <...>-77292 [003] 1175858.326650: function:
>   __ceph_caps_file_wanted
> 
>            <...>-77292 [003] 1175858.326650: function:
>      ceph_caps_for_mode
> 
>            <...>-77292 [003] 1175858.326650: function:
>   __ceph_caps_issued
> 
>            <...>-77292 [003] 1175858.326650: function:
>   _raw_spin_unlock
> 
>            <...>-77292 [003] 1175858.326650: function:
> prepare_to_wait_event
> 
>            <...>-77292 [003] 1175858.326650: function:
> try_get_cap_refs
> 
>            <...>-77292 [003] 1175858.326650: function:
>   _raw_spin_lock
> 
>            <...>-77292 [003] 1175858.326650: function:
>   __ceph_caps_file_wanted
> 
>            <...>-77292 [003] 1175858.326650: function:
>      ceph_caps_for_mode
> 
>            <...>-77292 [003] 1175858.326650: function:
>   __ceph_caps_issued
> 
>            <...>-77292 [003] 1175858.326651: function:
>   _raw_spin_unlock
> 
>            <...>-77292 [003] 1175858.326651: function:
> finish_wait
> 
>            <...>-77292 [003] 1175858.326651: function:             ceph_get_caps
> ... (lots of similar output)
> 
> I think it may be related to https://lkml.org/lkml/2019/5/23/172, but
> I wanted to get a second opinion.
> 
> Thank you,
> Robert LeBlanc
> ----------------
> Robert LeBlanc
> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1

What kernel version is this? Do you happen to have a more readable stack
trace? Did this come from a hung task warning in the kernel?

From this, it looks like it's stuck waiting on a spinlock, but it's
rather hard to tell for sure.
-- 
Jeff Layton <jlayton@kernel.org>

