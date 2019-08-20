Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 828FE96960
	for <lists+ceph-devel@lfdr.de>; Tue, 20 Aug 2019 21:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730292AbfHTT1Q convert rfc822-to-8bit (ORCPT
        <rfc822;lists+ceph-devel@lfdr.de>); Tue, 20 Aug 2019 15:27:16 -0400
Received: from linux-libre.fsfla.org ([209.51.188.54]:58468 "EHLO
        linux-libre.fsfla.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728185AbfHTT1P (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 20 Aug 2019 15:27:15 -0400
Received: from free.home (home.lxoliva.fsfla.org [172.31.160.164])
        by linux-libre.fsfla.org (8.15.2/8.15.2/Debian-3) with ESMTP id x7KJR6qw031664;
        Tue, 20 Aug 2019 19:27:07 GMT
Received: from livre (livre.home [172.31.160.2])
        by free.home (8.15.2/8.15.2) with ESMTPS id x7KJQtM4187696
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Tue, 20 Aug 2019 16:26:56 -0300
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
        <orblwk9xwp.fsf@lxoliva.fsfla.org>
        <CAJE9aONvV+mfCDWpFdE_cZBbaa91wS2ECXoYjqQ3i1h4HQmZrg@mail.gmail.com>
Date:   Tue, 20 Aug 2019 16:26:55 -0300
In-Reply-To: <CAJE9aONvV+mfCDWpFdE_cZBbaa91wS2ECXoYjqQ3i1h4HQmZrg@mail.gmail.com>
        (kefu chai's message of "Tue, 20 Aug 2019 17:08:14 +0800")
Message-ID: <ory2zn8wow.fsf@lxoliva.fsfla.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Scanned-By: MIMEDefang 2.84
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Aug 20, 2019, kefu chai <tchaikov@gmail.com> wrote:

> On Tue, Aug 20, 2019 at 2:03 PM Alexandre Oliva <oliva@gnu.org> wrote:
>> to build ceph so that it runs on such old and wise ;-) machines is not a
>> major problem.

> not at this moment =)

I can hardly imagine why it should ever be.  Being disk-bound, and
considering that even very old CPUs hardly have trouble keeping up with
the much slower storage devices, I can't imagine a reason for ceph or
anything portable across multiple architectures to tech to *demand*
newer CPUs of any of the supported architectures.  Hopefully there will
always be some portable fallback to resort to.

>> Next in my wishlist is to try to fix the issues that I'm told are
>> getting in the way of ceph's running on 32-bit x86.  If anyone is
>> familiar with them and could give me a brain dump to get me started,
>> that would certainly be appreciated.

> if you are able to pinpoint an FTBFS issue or bug while using Ceph on
> 32 bit platforms. i can take a look at it.

Oh, thanks, I didn't mean to burden anyone with that, it's just
something that I care about and would be happy to undertake myself.  I
was just surprised that there weren't i686 ceph packages in Fedora 30,
and found comments in the spec file suggesting it didn't work, but I
didn't look into why yet.

-- 
Alexandre Oliva, freedom fighter  he/him   https://FSFLA.org/blogs/lxo
Be the change, be Free!                 FSF Latin America board member
GNU Toolchain Engineer                        Free Software Evangelist
Hay que enGNUrecerse, pero sin perder la terGNUra jamás - Che GNUevara
