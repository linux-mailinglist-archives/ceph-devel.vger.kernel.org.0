Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F19DB4FCF
	for <lists+ceph-devel@lfdr.de>; Tue, 17 Sep 2019 16:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbfIQODK convert rfc822-to-8bit (ORCPT
        <rfc822;lists+ceph-devel@lfdr.de>); Tue, 17 Sep 2019 10:03:10 -0400
Received: from mail03.roosit.eu ([212.19.193.213]:42026 "EHLO mail03.roosit.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726188AbfIQODJ (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 17 Sep 2019 10:03:09 -0400
X-Greylist: delayed 2072 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Sep 2019 10:03:09 EDT
Received: from sx.f1-outsourcing.eu (host-213.189.39.136.telnetsolutions.pl [213.189.39.136] (may be forged))
        by mail03.roosit.eu (8.14.7/8.14.7) with ESMTP id x8HDSLUC028519
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO);
        Tue, 17 Sep 2019 15:28:23 +0200
Received: from sx.f1-outsourcing.eu (localhost.localdomain [127.0.0.1])
        by sx.f1-outsourcing.eu (8.13.8/8.13.8) with ESMTP id x8HDSKCK010023;
        Tue, 17 Sep 2019 15:28:20 +0200
Date:   Tue, 17 Sep 2019 15:28:20 +0200
From:   "Marc Roos" <M.Roos@f1-outsourcing.eu>
To:     adeza <adeza@redhat.com>, ceph-devel <ceph-devel@vger.kernel.org>,
        ceph-maintainers <ceph-maintainers@ceph.com>,
        ceph-users <ceph-users@ceph.io>
Message-ID: <"H00000710014f7db.1568726900.sx.f1-outsourcing.eu*"@MHS>
In-Reply-To: <CAC-Np1zjZJW2iqLVe720u_sxQDTKjoUqL9ftrqKbMcYbZQgYFQ@mail.gmail.com>
Subject: RE: [ceph-users] Re: download.ceph.com repository changes
x-scalix-Hops: 1
MIME-Version: 1.0
Content-Type: text/plain;
        charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

 
Just wanted to say we do not have any problems with current/past setup. 
Our ceph nodes are not even connected to the internet and we relay 
everything via 'our own local mirror'. 






-----Original Message-----
From: Alfredo Deza [mailto:adeza@redhat.com] 
Sent: dinsdag 17 september 2019 15:15
To: ceph-maintainers@ceph.com; ceph-users; ceph-devel
Subject: [ceph-users] Re: download.ceph.com repository changes

Reviving this old thread.

I still think this is something we should consider as users still 
experience problems:

* Impossible to 'pin' to a version. User installs 14.2.0 and 4 months 
later they add other nodes but version moved to 14.2.2
* Impossible to use a version that is not what the latest is (e.g. if 
someone doesn't need the release from Monday, but wants the one from 6 
months ago), similar to the above
* When a release is underway, the repository breaks because syncing 
packages takes hours. The operation is not atomic.
* It is not currently possible to "remove" a bad release, in the past, 
this means cutting a new release as soon as possible, which can take 
days

The latest issue (my fault!) was to cut a release and get the packages 
out without communicating with the release manager, which caused users 
to note there is a new version *as soon as it was up* vs, a process that 
could've not touched the 'latest' url until the announcement goes out.

If you have been affected by any of these issues (or others I didn't 
come up with), please let us know in this thread so that we can find 
some common ground and try to improve the process.

Thanks!

On Tue, Jul 24, 2018 at 10:38 AM Alfredo Deza <adeza@redhat.com> wrote:
>
> Hi all,
>
> After the 12.2.6 release went out, we've been thinking on better ways 
> to remove a version from our repositories to prevent users from 
> upgrading/installing a known bad release.
>
> The way our repos are structured today means every single version of 
> the release is included in the repository. That is, for Luminous, 
> every 12.x.x version of the binaries is in the same repo. This is true 

> for both RPM and DEB repositories.
>
> However, the DEB repos don't allow pinning to a given version because 
> our tooling (namely reprepro) doesn't construct the repositories in a 
> way that this is allowed. For RPM repos this is fine, and version 
> pinning works.
>
> To remove a bad version we have to proposals (and would like to hear 
> ideas on other possibilities), one that would involve symlinks and the 

> other one which purges the known bad version from our repos.
>
> *Symlinking*
> When releasing we would have a "previous" and "latest" symlink that 
> would get updated as versions move forward. It would require 
> separation of versions at the URL level (all versions would no longer 
> be available in one repo).
>
> The URL structure would then look like:
>
>     debian/luminous/12.2.3/
>     debian/luminous/previous/  (points to 12.2.5)
>     debian/luminous/latest/   (points to 12.2.7)
>
> Caveats: the url structure would change from debian-luminous/ to 
> prevent breakage, and the versions would be split. For RPMs it would 
> mean a regression if someone is used to pinning, for example pinning 
> to 12.2.2 wouldn't be possible using the same url.
>
> Pros: Faster release times, less need to move packages around, and 
> easier to remove a bad version
>
>
> *Single version removal*
> Our tooling would need to go and remove the known bad version from the 

> repository, which would require to rebuild the repository again, so 
> that the metadata is updated with the difference in the binaries.
>
> Caveats: time intensive process, almost like cutting a new release 
> which takes about a day (and sometimes longer). Error prone since the 
> process wouldn't be the same (one off, just when a version needs to be
> removed)
>
> Pros: all urls for download.ceph.com and its structure are kept the 
same.
_______________________________________________
ceph-users mailing list -- ceph-users@ceph.io To unsubscribe send an 
email to ceph-users-leave@ceph.io


