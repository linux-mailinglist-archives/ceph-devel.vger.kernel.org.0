Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F10A443EF6
	for <lists+ceph-devel@lfdr.de>; Thu, 13 Jun 2019 17:54:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389119AbfFMPyK convert rfc822-to-8bit (ORCPT
        <rfc822;lists+ceph-devel@lfdr.de>); Thu, 13 Jun 2019 11:54:10 -0400
Received: from mail-io1-f54.google.com ([209.85.166.54]:36434 "EHLO
        mail-io1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389556AbfFMPyF (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 13 Jun 2019 11:54:05 -0400
Received: by mail-io1-f54.google.com with SMTP id h6so18041617ioh.3
        for <ceph-devel@vger.kernel.org>; Thu, 13 Jun 2019 08:54:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+1odG3EXnhDEfYKQ+l2mMTuQNeu82UvsdZ8E0dVT/rY=;
        b=MYtf9j1Tk7jigzuiwg9NnRlq45GVlBXTcsBXwO1Y6a8zHTWKjU753fVUMRzb0zFGmY
         JZh8oSxeA2s7sTecuUPXvRE4H5WHePurVIl+7RoCPZLex1rzjNEA4xhWEz1AU1kA9NPF
         RVN7kYfxgykSBbNBFLYcfNzDSKiSzb+G1xcQ6SnY1snE7nwyt1PIQqVfbBpHTPAQAcV3
         oyUtVh+72If10LEgI+hlRX0MgAarcaeATwoalBLxAVEuCeAMzyhQHQ4MUfcS85gJMm3w
         olm/O/XD81Lw22FJu7qEPvntkBZa+gD0tqXLMaHegzuaaNXXbzSKk8UGjHGV/ypPuxzG
         dTrg==
X-Gm-Message-State: APjAAAUo7YFQNBTC1AY2/7Ce/VY4cXAC1P2hr0NUlvIGfYvLWIZZ1KQT
        CZjoN1KcHVXe5Z9GI7T7dP5UJdebLzp6E3Zy4x40f3XSu1Q=
X-Google-Smtp-Source: APXvYqyn4M6Wk3G2FfGYNaNwY7E73adLV3wv4hH9XX+oXDMeivO0g/tclgFIUd9nIMcgvVNPoO74Y4qcC8uD9qj9a/o=
X-Received: by 2002:a6b:641a:: with SMTP id t26mr2537415iog.3.1560441244953;
 Thu, 13 Jun 2019 08:54:04 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.DEB.2.11.1906061434200.13706@piezo.novalocal>
 <alpine.DEB.2.11.1906062131180.12100@piezo.novalocal> <alpine.DEB.2.11.1906111326130.32406@piezo.novalocal>
 <alpine.DEB.2.11.1906121438520.4977@piezo.novalocal> <17f88e39-45d7-d13b-0c42-db1f07195c26@suse.com>
 <alpine.DEB.2.11.1906131354420.12100@piezo.novalocal> <b2e59205-8cb7-235f-5b1f-651af75480da@suse.com>
In-Reply-To: <b2e59205-8cb7-235f-5b1f-651af75480da@suse.com>
From:   Mike Perez <miperez@redhat.com>
Date:   Thu, 13 Jun 2019 08:53:53 -0700
Message-ID: <CAFFUGJeWYcYaHPe30eeiZB2+_pNjjz0EC4Ps7rZFRrZ6TDmNug@mail.gmail.com>
Subject: Re: octopus planning calls
To:     Kai Wagner <kwagner@suse.com>
Cc:     Sage Weil <sage@newdream.net>,
        Ceph Development <ceph-devel@vger.kernel.org>, dev@ceph.io
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Just a reminder to everyone that the next planning call will be
happening in the next hour for Ceph FS.

https://bluejeans.com/522156210

--
Mike Perez (thingee)

On Thu, Jun 13, 2019 at 8:11 AM Kai Wagner <kwagner@suse.com> wrote:
>
>
> On 13.06.19 15:56, Sage Weil wrote:
> > Now we just need to figure out if that means November or March... :P
> Mentioned exactly that in the dashboard planning meeting atm - the more
> time the better ;-)
>
> --
> GF: Felix Imendörffer, Mary Higgins, Sri Rasiah HRB 21284 (AG Nürnberg)
>
>
