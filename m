Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3CB19570E
	for <lists+ceph-devel@lfdr.de>; Tue, 20 Aug 2019 08:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729000AbfHTGDb convert rfc822-to-8bit (ORCPT
        <rfc822;lists+ceph-devel@lfdr.de>); Tue, 20 Aug 2019 02:03:31 -0400
Received: from linux-libre.fsfla.org ([209.51.188.54]:56516 "EHLO
        linux-libre.fsfla.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727006AbfHTGDa (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 20 Aug 2019 02:03:30 -0400
Received: from free.home (home.lxoliva.fsfla.org [172.31.160.164])
        by linux-libre.fsfla.org (8.15.2/8.15.2/Debian-3) with ESMTP id x7K63Gu7017650;
        Tue, 20 Aug 2019 06:03:19 GMT
Received: from livre (livre.home [172.31.160.2])
        by free.home (8.15.2/8.15.2) with ESMTPS id x7K632SG162434
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Tue, 20 Aug 2019 03:03:03 -0300
From:   Alexandre Oliva <oliva@gnu.org>
To:     kefu chai <tchaikov@gmail.com>
Cc:     Brad Hubbard <bhubbard@redhat.com>,
        Tone Zhang <tone.zhang@linaro.org>,
        ceph-devel <ceph-devel@vger.kernel.org>, dev@ceph.io
Subject: Re: fix for hidden corei7 requirement in binary packages
Organization: Free thinker, not speaking for the GNU Project
References: <ord0h3gy6w.fsf@lxoliva.fsfla.org>
        <CAF-wwdEsyDC=X90ECi05a3FxWwbkv-gTTZAyfnB-N=K8KgNAPw@mail.gmail.com>
        <CAJE9aOObStUp7Xqcrp6g4yOntGZ81Z7unnYJ5jBeDG=8wg=DcQ@mail.gmail.com>
        <CAJE9aOMNvOmLc9=7LLCfZTUgiyjM20vpiE8a8v9iM8CyBVJE1g@mail.gmail.com>
Date:   Tue, 20 Aug 2019 03:03:02 -0300
In-Reply-To: <CAJE9aOMNvOmLc9=7LLCfZTUgiyjM20vpiE8a8v9iM8CyBVJE1g@mail.gmail.com>
        (kefu chai's message of "Mon, 19 Aug 2019 15:00:52 +0800")
Message-ID: <orblwk9xwp.fsf@lxoliva.fsfla.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Scanned-By: MIMEDefang 2.84
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Aug 19, 2019, kefu chai <tchaikov@gmail.com> wrote:

> after a second thought, i think, probably, instead of patching SPDK to
> cater the needs of older machines. a better option is to disable SPDK
> when building packages for testing and for our official releases.

I have no real clue on what role or impact disabling SPDK plays in the
grand scheme of things, so I'm happy to defer to whoever does.  I just
wish to keep my home ceph cluster running on those machines until I have
good reason to replace them.  Unfortunately that's the last generation
of x86 hardware that can run with a Free Software BIOS, and OpenPower
isn't so much of an option for home use.  I hope retaining the ability
to build ceph so that it runs on such old and wise ;-) machines is not a
major problem.

Next in my wishlist is to try to fix the issues that I'm told are
getting in the way of ceph's running on 32-bit x86.  If anyone is
familiar with them and could give me a brain dump to get me started,
that would certainly be appreciated.  I don't really have 32-bit
machines running ceph daemons, but I have often recommended ceph to
people who'd like to run it on SBCs connected to USB storage, so I was
quite surprised and disappointed to find out even x86 wouldn't work any
more.  Plus, that messed up my uniform selection of packages on x86 and
x86-64 machines with a single meta-package with all the dependencies I
care for ;-)

-- 
Alexandre Oliva, freedom fighter  he/him   https://FSFLA.org/blogs/lxo
Be the change, be Free!                 FSF Latin America board member
GNU Toolchain Engineer                        Free Software Evangelist
Hay que enGNUrecerse, pero sin perder la terGNUra jamás - Che GNUevara
