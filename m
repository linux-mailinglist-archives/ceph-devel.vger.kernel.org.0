Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04AE837A2F
	for <lists+ceph-devel@lfdr.de>; Thu,  6 Jun 2019 18:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728665AbfFFQyl (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 6 Jun 2019 12:54:41 -0400
Received: from mail-qt1-f180.google.com ([209.85.160.180]:40175 "EHLO
        mail-qt1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726778AbfFFQyl (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 6 Jun 2019 12:54:41 -0400
Received: by mail-qt1-f180.google.com with SMTP id a15so3458589qtn.7
        for <ceph-devel@vger.kernel.org>; Thu, 06 Jun 2019 09:54:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Lm5DoUAfw98nQaDe26Fr0fnlgIW9oyzUOo32TsFdM4o=;
        b=lvOv2KdzdyhaK+q7GmCppIO45L2qm14fhmyu5f8k5th22JebU1b/7C1ISQw2YDD6jh
         0KUp5Z30emujWeTpuXhZXJ8ZuIbhUKOmqQfuViziVLjfQExtH6vI5l/C3mQnkXBLYmdK
         dymuKFnACXBlAiBYnVtXNAmnP7qtBOFgqt4d8sZL+Bdqqz5z5ArC5xbw9yeprJHleuFA
         fwooqIaOBtfmB9+ywwmTCd6GnZUid5JWmxfkK/qoc6GsYAG9IGx5XXc18WP3AX0lwm00
         DTKZ05V1q3pWGAx6Sql+SG+XJpIKhPrumoGyttss/H3xYway+j4FWABLjV7XXIOwkoVh
         xJOQ==
X-Gm-Message-State: APjAAAUBNe519wB1vpiZ15vNRb/FAVKauxur1Dev4LuphWQGn+BbIfwq
        UU2CjG/6geIpIazVz9Jv9OiKDQYrnaoveCpP7U6gbQ==
X-Google-Smtp-Source: APXvYqwIV5jKj80pgO8v5RAdAVLo4s7aa0Q1r+NLqzR7NGW+T9OgR8l9s4D9+vxU+3W4DohXn7PCKrEMp4/rO3488UI=
X-Received: by 2002:a0c:d047:: with SMTP id d7mr38561308qvh.64.1559840080058;
 Thu, 06 Jun 2019 09:54:40 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.DEB.2.11.1906061434200.13706@piezo.novalocal>
In-Reply-To: <alpine.DEB.2.11.1906061434200.13706@piezo.novalocal>
From:   Neha Ojha <nojha@redhat.com>
Date:   Thu, 6 Jun 2019 09:54:29 -0700
Message-ID: <CAKn7kB=v-uD1-5Zc7pwxm7p6xYsJra+nmiSO4LUcrtN9kOkTrQ@mail.gmail.com>
Subject: Re: octopus planning calls
To:     Sage Weil <sweil@redhat.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>, dev@ceph.io
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Jun 6, 2019 at 8:15 AM Sage Weil <sweil@redhat.com> wrote:
>
> Hi everyone,
>
> We'd like to do some planning calls for octopus.  Each call would be 30-60
> minutes, and cover (at least) rados, rbd, rgw, and cephfs.  The dashboard
> team has a face to face meeting next week in Germany so they should be in
> good shape.  Sebastian, do we need to schedule something on the
> orchestrator, or just rely on the existing Monday call?
>
> 1- Does the 1500-1700 UTC time range work well enough for everyone?  We'll
> record the calls, of course, and send an email summary after.
>
> 2- What day(s):
>
>  Tomorrow (Friday Jun 7)
>  Next week (Jun 10-14... may conflict with dashboard f2f)
>  The following week (Jun 17-21)
>
> If notice isn't too short for tomorrow or Monday, it might be nice to have
> some clarity for the dashboard folks going into their f2f as far as what
> underlying work and new features are in the pipeline.
>
> Maybe... RADOS and RBD tomorrow, CephFS and RGW Monday?  Is that too much
> of a stretch?
Tomorrow (Friday June 7) 1500-1700 UTC works for RADOS.

- Neha
>
> sage
>
