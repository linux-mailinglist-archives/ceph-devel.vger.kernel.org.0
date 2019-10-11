Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3BBAD4A7C
	for <lists+ceph-devel@lfdr.de>; Sat, 12 Oct 2019 00:55:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbfJKWzk (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 11 Oct 2019 18:55:40 -0400
Received: from mail-qk1-f173.google.com ([209.85.222.173]:43393 "EHLO
        mail-qk1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726174AbfJKWzk (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 11 Oct 2019 18:55:40 -0400
Received: by mail-qk1-f173.google.com with SMTP id h126so10367686qke.10
        for <ceph-devel@vger.kernel.org>; Fri, 11 Oct 2019 15:55:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=leblancnet-us.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:date:message-id:subject:to;
        bh=WvKOU6ltSZctHvM8dBFLt6rNSSLtFlGQ2WQkkJYM2Uw=;
        b=nEeVf81Em6HMWgMp4GTlZRNWNgBXrRc1t3Dj0NN2LFkGfCbqarUG/N+dWVxvqyXwkG
         Zz0Nx7F9tzS23YUK6rux4KMmIWPvDWmUA0XkDr1rPQASXrpg8iq2pRu++nvKiF+hvx6x
         Xdz5qInhC8ixo/KvkwddSRV+T9Y3vbt5XoidrlkTKHMVw/WJI8dIWnUznJt9aGg6mpHX
         t/wRkC93evHn0XYIzu6yrBJ8k4hunhmTwt1xPhlmLAiDdJzxKFU67k18uEgBuxnOQYYJ
         su9SbH5PISNwvnmMaj6HLA5BVf+Izi44X3rRepiOl8fA00dU1+Ov0aLFWf1IJQU/Ayes
         A4pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=WvKOU6ltSZctHvM8dBFLt6rNSSLtFlGQ2WQkkJYM2Uw=;
        b=EfS/BgbnmjNYS95Vj3OFk9md7VmzVS90c8D9VvwadXTNQi2/M92ReNltrw4XtFFdaH
         1RKPVrRtaTBAXHKd8VgLc68h1n1ReBz/X6VnW5tyZQJPvJA66N9Acpz09DNy5Kmmv7yr
         5t9CMs+1cHHhvlzYLRmLeQ0xNHGiIpoP6fFM6z5FjBTfiQ8aGLmgKzDvHmie0PSWKeNj
         HTxFFUCV2vQUPkv841yEnEmu1PefILdo1mXQrWPHRNxtvc8g/ZHkkcpLEjHSZT76Esbi
         MphULcGNqMIgqrwdpzDwI6DYhn/8/4bkccymdFY1yPNvYD6VOfphJpp+orqBt6Wqkc0U
         GsFw==
X-Gm-Message-State: APjAAAWKRAevvrx0i5ON6osf/2bnrM9xWP0IjL+F9tyHdnbCEeZH+Ip1
        ERsaFw61ylNsDPG9gPDKyxvJr8Bbw+DT5nk8CHqM6ItBpsCMKA==
X-Google-Smtp-Source: APXvYqxsfv7wCRpDgHuwSBNsxzmy9ekiPa6q52LsMT7GK/7xcZicHJJfwfGu1JwXNl4nrbsOXGHyIyS6ISQtHLRG+K8=
X-Received: by 2002:ae9:e511:: with SMTP id w17mr15848012qkf.379.1570834538412;
 Fri, 11 Oct 2019 15:55:38 -0700 (PDT)
MIME-Version: 1.0
From:   Robert LeBlanc <robert@leblancnet.us>
Date:   Fri, 11 Oct 2019 15:55:27 -0700
Message-ID: <CAANLjFpQuOjeGkD_+0LNTeLystCKJ6WqA7A3X4vNgu8n+L8KWw@mail.gmail.com>
Subject: Hung CephFS client
To:     ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

We had a docker container that seems to be hung in the CephFS code
path. We were able to extract the following:

           <...>-77292 [003] 1175858.326638: function:
_raw_spin_lock

           <...>-77292 [003] 1175858.326640: function:             __wake_up

           <...>-77292 [003] 1175858.326641: function:
_raw_spin_lock_irqsave

           <...>-77292 [003] 1175858.326641: function:
__wake_up_common

           <...>-77292 [003] 1175858.326641: function:
_raw_spin_unlock_irqrestore

           <...>-77292 [003] 1175858.326641: function:             __wake_up

           <...>-77292 [003] 1175858.326641: function:
_raw_spin_lock_irqsave

           <...>-77292 [003] 1175858.326641: function:
__wake_up_common

           <...>-77292 [003] 1175858.326641: function:
  autoremove_wake_function

           <...>-77292 [003] 1175858.326641: function:
     default_wake_function

           <...>-77292 [003] 1175858.326641: function:
        try_to_wake_up

           <...>-77292 [003] 1175858.326642: function:
           _raw_spin_lock_irqsave

           <...>-77292 [003] 1175858.326642: function:
           task_waking_fair

           <...>-77292 [003] 1175858.326642: function:
           select_task_rq_fair

           <...>-77292 [003] 1175858.326642: function:
              source_load

           <...>-77292 [003] 1175858.326643: function:
              target_load

           <...>-77292 [003] 1175858.326643: function:
              effective_load.isra.45

           <...>-77292 [003] 1175858.326644: function:
              effective_load.isra.45

           <...>-77292 [003] 1175858.326644: function:
              select_idle_sibling

           <...>-77292 [003] 1175858.326645: function:
                 idle_cpu

           <...>-77292 [003] 1175858.326645: function:
           set_nr_if_polling

           <...>-77292 [003] 1175858.326645: function:
           ttwu_stat

           <...>-77292 [003] 1175858.326646: function:
           _raw_spin_unlock_irqrestore

           <...>-77292 [003] 1175858.326646: function:
_raw_spin_unlock_irqrestore

           <...>-77292 [003] 1175858.326646: function:             irq_exit

           <...>-77292 [003] 1175858.326646: function:
_raw_spin_unlock

           <...>-77292 [003] 1175858.326646: function:
try_get_cap_refs

           <...>-77292 [003] 1175858.326647: function:
_raw_spin_lock

           <...>-77292 [003] 1175858.326647: function:
__ceph_caps_file_wanted

           <...>-77292 [003] 1175858.326647: function:
  ceph_caps_for_mode

           <...>-77292 [003] 1175858.326647: function:
__ceph_caps_issued

           <...>-77292 [003] 1175858.326647: function:
_raw_spin_unlock

           <...>-77292 [003] 1175858.326647: function:             _cond_resched

           <...>-77292 [003] 1175858.326647: function:
try_get_cap_refs

           <...>-77292 [003] 1175858.326647: function:
_raw_spin_lock

           <...>-77292 [003] 1175858.326647: function:
__ceph_caps_file_wanted

           <...>-77292 [003] 1175858.326647: function:
  ceph_caps_for_mode

           <...>-77292 [003] 1175858.326647: function:
__ceph_caps_issued

           <...>-77292 [003] 1175858.326647: function:
_raw_spin_unlock

           <...>-77292 [003] 1175858.326647: function:
prepare_to_wait_event

           <...>-77292 [003] 1175858.326647: function:
try_get_cap_refs

           <...>-77292 [003] 1175858.326647: function:
_raw_spin_lock

           <...>-77292 [003] 1175858.326647: function:
__ceph_caps_file_wanted

           <...>-77292 [003] 1175858.326647: function:
  ceph_caps_for_mode

           <...>-77292 [003] 1175858.326648: function:
__ceph_caps_issued

           <...>-77292 [003] 1175858.326648: function:
_raw_spin_unlock

           <...>-77292 [003] 1175858.326648: function:             finish_wait

           <...>-77292 [003] 1175858.326648: function:             ceph_get_caps

           <...>-77292 [003] 1175858.326648: function:
ceph_pool_perm_check

           <...>-77292 [003] 1175858.326648: function:
  _raw_spin_lock

           <...>-77292 [003] 1175858.326648: function:
  _raw_spin_unlock

           <...>-77292 [003] 1175858.326648: function:
try_get_cap_refs

           <...>-77292 [003] 1175858.326648: function:
  _raw_spin_lock

           <...>-77292 [003] 1175858.326648: function:
  __ceph_caps_file_wanted

           <...>-77292 [003] 1175858.326648: function:
     ceph_caps_for_mode

           <...>-77292 [003] 1175858.326648: function:
  __ceph_caps_issued

           <...>-77292 [003] 1175858.326648: function:
  _raw_spin_unlock

           <...>-77292 [003] 1175858.326648: function:
_cond_resched

           <...>-77292 [003] 1175858.326648: function:
try_get_cap_refs

           <...>-77292 [003] 1175858.326648: function:
  _raw_spin_lock

           <...>-77292 [003] 1175858.326649: function:
  __ceph_caps_file_wanted

           <...>-77292 [003] 1175858.326649: function:
     ceph_caps_for_mode

           <...>-77292 [003] 1175858.326649: function:
  __ceph_caps_issued

           <...>-77292 [003] 1175858.326649: function:
  _raw_spin_unlock

           <...>-77292 [003] 1175858.326649: function:
prepare_to_wait_event

           <...>-77292 [003] 1175858.326649: function:
try_get_cap_refs

           <...>-77292 [003] 1175858.326649: function:
  _raw_spin_lock

           <...>-77292 [003] 1175858.326649: function:
  __ceph_caps_file_wanted

           <...>-77292 [003] 1175858.326649: function:
     ceph_caps_for_mode

           <...>-77292 [003] 1175858.326649: function:
  __ceph_caps_issued

           <...>-77292 [003] 1175858.326649: function:
  _raw_spin_unlock

           <...>-77292 [003] 1175858.326649: function:
finish_wait

           <...>-77292 [003] 1175858.326649: function:             ceph_get_caps

           <...>-77292 [003] 1175858.326649: function:
ceph_pool_perm_check

           <...>-77292 [003] 1175858.326649: function:
  _raw_spin_lock

           <...>-77292 [003] 1175858.326649: function:
  _raw_spin_unlock

           <...>-77292 [003] 1175858.326649: function:
try_get_cap_refs

           <...>-77292 [003] 1175858.326649: function:
  _raw_spin_lock

           <...>-77292 [003] 1175858.326649: function:
  __ceph_caps_file_wanted

           <...>-77292 [003] 1175858.326650: function:
     ceph_caps_for_mode

           <...>-77292 [003] 1175858.326650: function:
  __ceph_caps_issued

           <...>-77292 [003] 1175858.326650: function:
  _raw_spin_unlock

           <...>-77292 [003] 1175858.326650: function:
_cond_resched

           <...>-77292 [003] 1175858.326650: function:
try_get_cap_refs

           <...>-77292 [003] 1175858.326650: function:
  _raw_spin_lock

           <...>-77292 [003] 1175858.326650: function:
  __ceph_caps_file_wanted

           <...>-77292 [003] 1175858.326650: function:
     ceph_caps_for_mode

           <...>-77292 [003] 1175858.326650: function:
  __ceph_caps_issued

           <...>-77292 [003] 1175858.326650: function:
  _raw_spin_unlock

           <...>-77292 [003] 1175858.326650: function:
prepare_to_wait_event

           <...>-77292 [003] 1175858.326650: function:
try_get_cap_refs

           <...>-77292 [003] 1175858.326650: function:
  _raw_spin_lock

           <...>-77292 [003] 1175858.326650: function:
  __ceph_caps_file_wanted

           <...>-77292 [003] 1175858.326650: function:
     ceph_caps_for_mode

           <...>-77292 [003] 1175858.326650: function:
  __ceph_caps_issued

           <...>-77292 [003] 1175858.326651: function:
  _raw_spin_unlock

           <...>-77292 [003] 1175858.326651: function:
finish_wait

           <...>-77292 [003] 1175858.326651: function:             ceph_get_caps
... (lots of similar output)

I think it may be related to https://lkml.org/lkml/2019/5/23/172, but
I wanted to get a second opinion.

Thank you,
Robert LeBlanc
----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
