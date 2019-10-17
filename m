Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2305DAB07
	for <lists+ceph-devel@lfdr.de>; Thu, 17 Oct 2019 13:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439646AbfJQLQl (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 17 Oct 2019 07:16:41 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:39727 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406044AbfJQLQl (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 17 Oct 2019 07:16:41 -0400
Received: by mail-io1-f65.google.com with SMTP id a1so2482798ioc.6
        for <ceph-devel@vger.kernel.org>; Thu, 17 Oct 2019 04:16:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=7hnA31FCHqKMkxaNgn5KklQGxQzFTCS3VKLjKX0TTAg=;
        b=hnt01dPxFTLahXWAvd2Y+Ixz2/EzFoSQ0cn7dQTFseE/VSEkIhTpvi2Gmh+aYhCxQo
         JGUMcwscgJsFHphErENj29fC+KjUOiNe+sgozU/KpGaR0mQxfRafP0pBGY516qzbkwOs
         CCXna/TFPglgRf1Wx+Nz/NA1Tepzx6c0fkxh07hR49NI1JV3rbUcu9bzMoF1TCltwH3u
         e93zvZf9X564mPgyNfAmEsHD6kZU9fJwom9bpcd/j/L9QmEN7IbCllLJqfJ5XRmd7f6j
         ZoUzUH7jq4KGmXci49/49uufxOV652tnTQL5mBjLnXVVKZgMrnPapZ3PEIwYWywwOhOV
         FxYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7hnA31FCHqKMkxaNgn5KklQGxQzFTCS3VKLjKX0TTAg=;
        b=gMdVY0ElpqIGPebTEtjKPMXhM39u01ic+18/iMu+KLPxtaQx+zQPBUaStHkgRKupJA
         FqApeaT+2G/G3IgzsPEKkBhb/s2prRQAIxry73OmLIj2A9pH3EZaY/qQ9cQBREHiL+bM
         s9LYkvZR2Rc1aay4JLr4oU7zY4P97MdoCDQtX9kvDcTwn57Jg6G+a1dt8TK0tiTuyzEV
         Kvc1jX2nABfk9i5envBIwCB9PJ0rI/q0wI3CiTlauvGZ/vfh8ENugNQavkaAmRVQsF9r
         9av/Uhr9efq5BbP55Emk/kbUJVEn/RCfTsPO4hSPclDQFPyMHqPIdiOvJLNElr6bWA/X
         tgZw==
X-Gm-Message-State: APjAAAXOSau5hZx3+EOgF3CR33dounboIow8xapuZ0sscm5WBmcklHrg
        gnTjwmOQw+D9GWffxNM4wWCK9vYnV9ngVWoLWS9tY52W
X-Google-Smtp-Source: APXvYqwuVzrqUeqcJmyarYtuvzL6QL/GRC9IKRmU2ggWhtF4IYEtEWGN6dlJ2zEPo+p2GCO+1pDM+S2nowm2O5iEKoo=
X-Received: by 2002:a5d:884f:: with SMTP id t15mr2473927ios.224.1571311000545;
 Thu, 17 Oct 2019 04:16:40 -0700 (PDT)
MIME-Version: 1.0
References: <CAMrPN_JjckOAnQC_=C+YJ1+QTMRbUkGSu24Pyuo1EC=rfXGuRQ@mail.gmail.com>
 <CALZt5jz3F45NJZpPwAzcegtVcf6556z07MCTJx2Q0e4q8Jb5wg@mail.gmail.com>
 <CAMrPN_Jz2UaBCRuUUfb1-bwPEgvgEk7BJK4kTD35Tmt_ZBXK0w@mail.gmail.com> <20191016155827.cwd4vrvul4aawyrq@suse.com>
In-Reply-To: <20191016155827.cwd4vrvul4aawyrq@suse.com>
From:   "Honggang(Joseph) Yang" <eagle.rtlinux@gmail.com>
Date:   Thu, 17 Oct 2019 19:16:29 +0800
Message-ID: <CAMrPN_Jyv6E8PmBDM_2KY2qNNOhJpC9SH=Bzw4eq75dcaEM9gA@mail.gmail.com>
Subject: Re: local mode -- a new tier mode
To:     Lars Marowsky-Bree <lmb@suse.com>
Cc:     dev@ceph.io, ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 17 Oct 2019 at 06:22, Lars Marowsky-Bree <lmb@suse.com> wrote:
>
> On 2019-10-16T11:28:25, " Honggang(Joseph) Yang " <eagle.rtlinux@gmail.co=
m> wrote:
>
> I'm glad to see more performance work and caching happening in Ceph!
>
> I admit calling this a "tier" (to get the bike shedding done first ;-)
> is confusing me, because that used to mean something different. This
> seems to me to be more of a BlueStore feature based on hints/access from
> the upper layers?
>

User can explicitly send hint op or the do_op/agent send hint op based on o=
bject
access statistics to trigger a migration.

> So perhaps, at that level, it'd make sense to instead use the space on
> the RocksDB partition/device for this caching operation, instead of yet
> an additional device? (Intuitively, that's what most users already
> expect it does, anyway.)

yes, this is user friendly.

>
> How would this, compared to bcache, possibly handle situations where
> multiple OSDs share one caching device?
>

SSD is split into multiple partitions. Each partition is assigned  to
an osd as fast partitions.

> And does this only promote the local shard/replica? I'm wondering how
> this would affect EC pools.
>

yes, only promote the local shard/replica. But there is still some
work to do to support ec pool.

>
> Regards,
>     Lars
>
> --
> SUSE Linux GmbH, GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah, HR=
B 21284 (AG N=C3=BCrnberg)
> "Architects should open possibilities and not determine everything." (Uel=
i Zbinden)
