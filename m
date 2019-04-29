Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFEE0E640
	for <lists+ceph-devel@lfdr.de>; Mon, 29 Apr 2019 17:24:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728700AbfD2PYc (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 29 Apr 2019 11:24:32 -0400
Received: from mail-ed1-f53.google.com ([209.85.208.53]:45720 "EHLO
        mail-ed1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728430AbfD2PYc (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 29 Apr 2019 11:24:32 -0400
Received: by mail-ed1-f53.google.com with SMTP id g57so2925700edc.12
        for <ceph-devel@vger.kernel.org>; Mon, 29 Apr 2019 08:24:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vanderster.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=whkdizLQLmafy8TbWGGN1wHLnpAEWAu25bi9rXW54IE=;
        b=WPp+8Lxb/ExOH/Pv1vsI9FjmLAfS1Q5fUMHIlXQrT5PU0waJyG9SWT5iJV4O23pNlx
         T6cCoxDjqal22DoylDnuJ2u2NTJsy5DZ3Bre/zTdu1XwbgpXhZF6F6fBcTHqDTlHLanf
         GTY1fhPsR8XOkPOHDcmocTlCm12Qx9R+WGGPA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=whkdizLQLmafy8TbWGGN1wHLnpAEWAu25bi9rXW54IE=;
        b=EfCf9SMRlomnaTu9/sKFPfo6c79Ff/OPBSWfks1CX4ETzk/rVKKxep4qSa7PCoRGUr
         JaCsD6tnSTPlFQpf2TkqTThebXhW6Lz3WVXWzQdjaBVfiMagyrGcwvGRzrQL8qXpoF3D
         5v9sSW8zitJxm16V1JRb8hgPh3l+XRedzvC1JLykhA6BWUjAxkrWz2RLsLWGwmaR+2iM
         oMQI+c11bQCAPVzjXRVE+fp8WaHJQqD3+pWa3JAJzTKRJxEkG3HwNU4Pk0aE97jJamga
         LmuJkP1Tsh+eWXwSEhmNCgCIJ0jHQty4xxJ9yb42Zcx6RizS48ucRlsJaw3CPNQGDis9
         eKBA==
X-Gm-Message-State: APjAAAWSHu/T5/TC2+qzK949X6ScChjuQLFGKnio6+Bb1gpxpjoQN1mC
        VnVX7Q4un5zxi0ByTOwg9rExcXcDStc=
X-Google-Smtp-Source: APXvYqx8VLZy2XJs6iE08hQyChzJzfHtA75wD8uBLXM5to08T9JyNb/gGkWAbko7V4m4A/f2Eljulw==
X-Received: by 2002:a50:b321:: with SMTP id q30mr5585129edd.275.1556551470690;
        Mon, 29 Apr 2019 08:24:30 -0700 (PDT)
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com. [209.85.221.51])
        by smtp.gmail.com with ESMTPSA id m3sm3966079ejc.5.2019.04.29.08.24.28
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Apr 2019 08:24:28 -0700 (PDT)
Received: by mail-wr1-f51.google.com with SMTP id c12so16629734wrt.8
        for <ceph-devel@vger.kernel.org>; Mon, 29 Apr 2019 08:24:28 -0700 (PDT)
X-Received: by 2002:adf:f0c9:: with SMTP id x9mr2108755wro.147.1556551468188;
 Mon, 29 Apr 2019 08:24:28 -0700 (PDT)
MIME-Version: 1.0
References: <20190429150725.4b3sijovqn5hi4ik@jfsuselaptop>
In-Reply-To: <20190429150725.4b3sijovqn5hi4ik@jfsuselaptop>
From:   Dan van der Ster <dan@vanderster.com>
Date:   Mon, 29 Apr 2019 17:23:52 +0200
X-Gmail-Original-Message-ID: <CABZ+qqmL25T6D-tKMAvKMBaheb0i_gkZmn+C-oRET-VfoiOQmw@mail.gmail.com>
Message-ID: <CABZ+qqmL25T6D-tKMAvKMBaheb0i_gkZmn+C-oRET-VfoiOQmw@mail.gmail.com>
Subject: Re: ceph-volume and multi-PV Volume groups
To:     "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Apr 29, 2019 at 5:07 PM Jan Fajerski <jfajerski@suse.com> wrote:
> Hi all,
> I'd like to request feedback regarding http://tracker.ceph.com/issues/375=
02.
> This regards the ceph-volume lvm batch subcommand and its handling of mul=
it-PV
> Volume Groups. The details are in the tracker ticket, the gist is that in
> certain circumstances ceph-volume creates LVM setups where a single bad d=
rive
> that is used for db/wal can bring down unrelated OSDs (OSDs that have the=
ir LVs
> on completely separate drives) and thus impact a cluster fault tolerance.
>
> I'm aware that one could work around this by creating the LVM setup that =
I want.

The much simpler workaround is to run `lvm batch` once for each db
device. (so run in twice in your 2 ssd + 10 hdd example).
We're pretty content with that workaround in our prod env.

That said, I agree that the default should be to create a vg for each
db device, because in addition to your tooling point below, (a) db's
on a multi-dev linear vg is total nonsense imho, nobody wants that in
prod, and (b) the tool seems arbitrarily inconsistent -- it creates a
unique vg per data dev but one vg for all db devs! (one vg for all
data devs is clearly bad, as is one vg for all db devices, imho).

my 2 rappen,

dan

> I think this is a bad approach though since every deployment tool has to
> implement its own LVM handling code. Imho the right place for this is exa=
ctly
> ceph-volume.
>
> Jan
>
> --
> Jan Fajerski
> Engineer Enterprise Storage
> SUSE Linux GmbH, GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah
> HRB 21284 (AG N=C3=BCrnberg)
