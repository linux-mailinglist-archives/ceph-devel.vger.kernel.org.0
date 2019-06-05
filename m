Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 953BD3669C
	for <lists+ceph-devel@lfdr.de>; Wed,  5 Jun 2019 23:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbfFEVRK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 5 Jun 2019 17:17:10 -0400
Received: from mail-qt1-f177.google.com ([209.85.160.177]:39387 "EHLO
        mail-qt1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726527AbfFEVRK (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 5 Jun 2019 17:17:10 -0400
Received: by mail-qt1-f177.google.com with SMTP id i34so251779qta.6
        for <ceph-devel@vger.kernel.org>; Wed, 05 Jun 2019 14:17:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gbqp5bx9qyVxkLxaR9fG2uFoCs6utycng5C1GMn9m6g=;
        b=aU/4PXJM5URmFvievNcJ3xX518GjBCbWkM7ZrBmqawTz30XJHO6ClzqWlVw8QBh2Ks
         bD+t4ompKSujMBm5y9fnoyAOYRmih53mCKzDOQXx4eGMe2C6WUpV4nqFc6ZUBGmcjCWy
         4THup1nBM5b+7aVi213eBrHVrtgikNc4HDiCPR1Rp254RRgCX/Qh7UWC434FMSClPdyD
         XjfKsDyGNUE7REiYZaoMb/HnrGgqRulxet9Ex7jx0nKqGnfdcoUYJVLw8khFJuZ/ziiD
         7QQGYSO3Duhh4q7fgdScgir7A/y/PNN+Ibhi3m/lPc5dFS4A7M7aE1JC09JWmQG+h3dQ
         +uhw==
X-Gm-Message-State: APjAAAWzKCdqqQV4LvsWBPjPOoYv0TV3yPoZoeV2h1ZvN9ETe+yjKhxT
        zEKsu1Ft0W2cFdR0HivL+iCP9YdZGNBh3e7cwGnhfdMS
X-Google-Smtp-Source: APXvYqxdGWRwZNhGaqSZQMGCwwIaCMNy8agUya4w6RegldscquZ9yBzbygdMx0XKyVLhfceg/tZGQO87TvggM4sDI+k=
X-Received: by 2002:ac8:374d:: with SMTP id p13mr35888509qtb.389.1559769429198;
 Wed, 05 Jun 2019 14:17:09 -0700 (PDT)
MIME-Version: 1.0
References: <20190603092600.covgtxixlsgmw3mt@jfsuselaptop>
In-Reply-To: <20190603092600.covgtxixlsgmw3mt@jfsuselaptop>
From:   Patrick Donnelly <pdonnell@redhat.com>
Date:   Wed, 5 Jun 2019 14:16:43 -0700
Message-ID: <CA+2bHPZ0jkoNWPBKcAWWe0=k8jwxUURPpOVaKKx0GZdo7rYC2Q@mail.gmail.com>
Subject: Re: luminous ceph_volume_client against a nautilus cluster
To:     ceph-devel <ceph-devel@vger.kernel.org>
Cc:     Ramana Venkatesh Raja <rraja@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hello Jan,

On Mon, Jun 3, 2019 at 2:26 AM Jan Fajerski <jfajerski@suse.com> wrote:
> I've asked about this in IRC already, but due to timezone foo ceph-devel might
> be more effective.
> I was wondering if there was a plan or expectation of creating cephfs subvolumes
> using a luminous ceph_volume_client on a nautilus cluster (or any other sensible
> version combination)?

I do not think so. We do plan to have Nautilus clusters continue to
function with the old ceph_volume_client.py clients.

> Currently this does not work, due to the volume client using the now removed
> 'ceph mds dump' command. The fix is straight forward, but depending on if that
> should work this could be more complex (essentially making ceph_volume_client
> aware of the version of the ceph cluster).

... so this is a bug. Is there a tracker ticket open for this yet?

> I'm aware of the current refactor of the volume client as a mgr module. Will we
> backport this to luminous?

No.

>Or is there an expectation that the volume client and
> the ceph cluster have to run the same version?

That's what we'd like yes. I think the tricky part is dealing with
applications (like Manila) using an older ceph_volume_client.py. We
could backport a switch in the library so that it uses the new `ceph
fs volume` commands if the cluster is Nautilus+. I'm not sure that is
really needed though.

-- 
Patrick Donnelly, Ph.D.
He / Him / His
Senior Software Engineer
Red Hat Sunnyvale, CA
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D
