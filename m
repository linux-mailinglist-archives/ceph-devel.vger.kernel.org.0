Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7A5231620
	for <lists+ceph-devel@lfdr.de>; Fri, 31 May 2019 22:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727459AbfEaU1I (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 31 May 2019 16:27:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42668 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727287AbfEaU1I (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 31 May 2019 16:27:08 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0FC9F2ED2E3;
        Fri, 31 May 2019 20:27:08 +0000 (UTC)
Received: from ovpn-112-65.rdu2.redhat.com (ovpn-112-65.rdu2.redhat.com [10.10.112.65])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2FCC060CAB;
        Fri, 31 May 2019 20:26:59 +0000 (UTC)
Date:   Fri, 31 May 2019 20:26:58 +0000 (UTC)
From:   Sage Weil <sweil@redhat.com>
X-X-Sender: sage@piezo.novalocal
To:     Yuri Weinstein <yweinste@redhat.com>
cc:     Josh Durgin <jdurgin@redhat.com>, Sebastien Han <shan@redhat.com>,
        Matt Benjamin <mbenjamin@redhat.com>,
        Jeff Layton <jlayton@redhat.com>,
        Alfredo Deza <adeza@redhat.com>,
        "Sadeh-Weinraub, Yehuda" <yehuda@redhat.com>,
        ceph-qe-team <ceph-qe-team@redhat.com>,
        ceph-qa <ceph-qa@ceph.com>,
        "Development, Ceph" <ceph-devel@vger.kernel.org>,
        Venky Shankar <vshankar@redhat.com>
Subject: Re: [Ceph-qa] 13.2.6 QE Mimic validation status
In-Reply-To: <CAMMFjmFOGru6K3O00D9a+==VwZV4qBZKHHyjHsdCRm+CDi9jQg@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1905312026440.29593@piezo.novalocal>
References: <CAMMFjmF1SP9JnyeuqCtsS9KJKRO-1R+E+NkzO-kj6+pn=chfzw@mail.gmail.com> <CAC-Np1wR4ik58P=UPLuuBxhqbG_REx1UFp4mDPNdBiNQFW9W_g@mail.gmail.com> <CAMMFjmGro96-bhMOe2KGYjZLAu-6RrNKAvOom+wP3ovg_+ss7Q@mail.gmail.com> <fc64e04b-bae8-8e3c-a561-ab3d0d1489a3@redhat.com>
 <CAMMFjmFOGru6K3O00D9a+==VwZV4qBZKHHyjHsdCRm+CDi9jQg@mail.gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Fri, 31 May 2019 20:27:08 +0000 (UTC)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 31 May 2019, Yuri Weinstein wrote:
> All runs were approved.
> See only ceph-deploy that sees not bad, Sage.
> 
> Also note that 3 commits were merged on top (related to upgrade/mimic-p2p fixes)
> 
> I did not rerun all suites on the latest SHA1, so if this is a problem
> pls speak up.
> 
> Otherwise, Sage, Abhishek, Nathan, David ready for publishing.

Sounds good to me!  Let's wait until Monday, though :)

sage
