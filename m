Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7024C37AB3
	for <lists+ceph-devel@lfdr.de>; Thu,  6 Jun 2019 19:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728712AbfFFROH (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 6 Jun 2019 13:14:07 -0400
Received: from mail-qt1-f170.google.com ([209.85.160.170]:40005 "EHLO
        mail-qt1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727522AbfFFROG (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 6 Jun 2019 13:14:06 -0400
Received: by mail-qt1-f170.google.com with SMTP id a15so3535531qtn.7
        for <ceph-devel@vger.kernel.org>; Thu, 06 Jun 2019 10:14:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AnLaX7fHvbIIDylP09JjITW2JhZBdpO6lh9QMn1MXA8=;
        b=ZAgDb65yikVUCyxxViv62thqNT2VGkrQ3iDRnYjaz9rP3OGUxr9+Xc6KvGLUmijMbz
         3F9jpbjjdMpZsdrS1dLcv2dHs8yXPgI4W/tzn004crXKUXesKAH+dW2BcmwdMU6PgRHI
         NLmflAVOUpeYpRBQ4GJuUvEjRZ8xpF6kO9wxdC2Fb2Go0XvfJWx5rtIa3oYl4m5AeNgW
         34YlF/IeBvasdPrxEfjbE23s/ndTvjEdPk8xy6KS3bW9gvydS3QxSG5/JSY0ZE26I3Lo
         iH/0VwHmtcgoRcgbKibhhFk2Kv2zUVS5G4G+66vCD4shbCfpIcmPJT+mrbTYfAAkoCk9
         m2TQ==
X-Gm-Message-State: APjAAAV35BKxhi0goSBUGXYPxMEvHkO+OJKFgFkeNOFXmratHL2YTqLM
        GWjr7cx34zold+TAoDiSkCHGphOVxU9xZp4Tdzhrjr9R
X-Google-Smtp-Source: APXvYqwWy1b/PHxM3tvGq6dt2pWZX38+Vyyl46Z0zWTHpjjP/9swpyYVRfpiX5DpSEzU7FBxX2UuGRGCdBxw5C1UAyw=
X-Received: by 2002:a0c:c164:: with SMTP id i33mr21375890qvh.37.1559841245663;
 Thu, 06 Jun 2019 10:14:05 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.DEB.2.11.1906061434200.13706@piezo.novalocal>
In-Reply-To: <alpine.DEB.2.11.1906061434200.13706@piezo.novalocal>
From:   Patrick Donnelly <pdonnell@redhat.com>
Date:   Thu, 6 Jun 2019 10:13:39 -0700
Message-ID: <CA+2bHPZT81Dm+_tJBwqeqLefZ=JM2buK2R=RN=VicnAR3iwvYQ@mail.gmail.com>
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

Tomorrow is no good for me. Monday at 1500 UTC (8am PDT if Google is
truthful) works.

-- 
Patrick Donnelly, Ph.D.
He / Him / His
Senior Software Engineer
Red Hat Sunnyvale, CA
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D
