Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46A9FB5EC5
	for <lists+ceph-devel@lfdr.de>; Wed, 18 Sep 2019 10:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727958AbfIRIKY (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 18 Sep 2019 04:10:24 -0400
Received: from smtp4.epfl.ch ([128.178.224.219]:50628 "EHLO smtp4.epfl.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727718AbfIRIKX (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 18 Sep 2019 04:10:23 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Sep 2019 04:10:22 EDT
Received: (qmail 24392 invoked by uid 107); 18 Sep 2019 08:03:40 -0000
Received: from icdhcp-1-099.epfl.ch (HELO [128.178.116.99]) (128.178.116.99) (TLS, ECDHE-RSA-AES256-GCM-SHA384 (X25519 curve) cipher) (authenticated)
  by mail.epfl.ch (AngelmatoPhylax SMTP proxy) with ESMTPSA; Wed, 18 Sep 2019 10:03:40 +0200
X-EPFL-Auth: Ux0RlM0qGJavF8/atvDbLs+7EQRO8w4DPr6XcDV8XbEnmdLSB6M=
Subject: Re: [ceph-users] Re: download.ceph.com repository changes
To:     ceph-users@ceph.io, ceph-maintainers@ceph.com,
        ceph-devel <ceph-devel@vger.kernel.org>
References: <CAC-Np1zTk1G-LF3eJiqzSF8SS=h=Jrr261C4vHdgmmwcqhUeXQ@mail.gmail.com>
 <CAC-Np1zjZJW2iqLVe720u_sxQDTKjoUqL9ftrqKbMcYbZQgYFQ@mail.gmail.com>
From:   Yoann Moulin <yoann.moulin@epfl.ch>
Openpgp: preference=signencrypt
Autocrypt: addr=yoann.moulin@epfl.ch; prefer-encrypt=mutual; keydata=
 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
 mddYk2TVgA==
Message-ID: <a39333c9-ccb5-affe-5769-866044aa13ba@epfl.ch>
Date:   Wed, 18 Sep 2019 10:03:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAC-Np1zjZJW2iqLVe720u_sxQDTKjoUqL9ftrqKbMcYbZQgYFQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: fr-CH
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hello,

> I still think this is something we should consider as users still
> experience problems:
> 
> * Impossible to 'pin' to a version. User installs 14.2.0 and 4 months
> later they add other nodes but version moved to 14.2.2
> * Impossible to use a version that is not what the latest is (e.g. if
> someone doesn't need the release from Monday, but wants the one from 6
> months ago), similar to the above

I think this could be a good idea, even if there is bugfix in next release, sometimes you don't want to fix a version in a stable cluster. I use
CEPH-ansible but I don't know if it's possible to choose a release that is not the latest.

> * When a release is underway, the repository breaks because syncing
> packages takes hours. The operation is not atomic.

Maybe build package on another server or tl least on another repo and when it's done, move all of them in one atomic operation after last tests?

So we can imagine having a prerelease channel where volunteers can use it and test and let the stable official repo untouched until it's ready.

Asking CEPH users to maintain a local repo just to keep a specific version installabled for himself is a bit hard and not what I expect from a
machine critical storage solution.

> * It is not currently possible to "remove" a bad release, in the past,
> this means cutting a new release as soon as possible, which can take
> days

This is also an important process to setup, Ceph is used for critical infrastructure, there are already plenty of tests and is really stable but
we all know how a bug can be malicious and destructive and how quickly users can lose confidence in it. Be able to remove, quickly, a buggy
package is a must I think. And this will be a guarantee of quality to your users.

> The latest issue (my fault!) was to cut a release and get the packages
> out without communicating with the release manager, which caused users
> to note there is a new version *as soon as it was up* vs, a
> process that could've not touched the 'latest' url until the
> announcement goes out.

In French, we say something like "There are two kinds of administrators, those who have made mistakes under root, and those who will do it."
(I'm a member of the first group.) But processes are here to avoid or at least reduce the impact of those mistakes. And this is why we use CEPH,
its  design can avoid some mistakes as root. Invest a few time to improve the release process may increase even more confidence in Ceph.

> If you have been affected by any of these issues (or others I didn't
> come up with), please let us know in this thread so that we can find
> some common ground and try to improve the process.

my 2 cents,

Best,

> On Tue, Jul 24, 2018 at 10:38 AM Alfredo Deza <adeza@redhat.com> wrote:
>>
>> Hi all,
>>
>> After the 12.2.6 release went out, we've been thinking on better ways
>> to remove a version from our repositories to prevent users from
>> upgrading/installing a known bad release.
>>
>> The way our repos are structured today means every single version of
>> the release is included in the repository. That is, for Luminous,
>> every 12.x.x version of the binaries is in the same repo. This is true
>> for both RPM and DEB repositories.
>>
>> However, the DEB repos don't allow pinning to a given version because
>> our tooling (namely reprepro) doesn't construct the repositories in a
>> way that this is allowed. For RPM repos this is fine, and version
>> pinning works.
>>
>> To remove a bad version we have to proposals (and would like to hear
>> ideas on other possibilities), one that would involve symlinks and the
>> other one which purges the known bad version from our repos.
>>
>> *Symlinking*
>> When releasing we would have a "previous" and "latest" symlink that
>> would get updated as versions move forward. It would require
>> separation of versions at the URL level (all versions would no longer
>> be available in one repo).
>>
>> The URL structure would then look like:
>>
>>     debian/luminous/12.2.3/
>>     debian/luminous/previous/  (points to 12.2.5)
>>     debian/luminous/latest/   (points to 12.2.7)
>>
>> Caveats: the url structure would change from debian-luminous/ to
>> prevent breakage, and the versions would be split. For RPMs it would
>> mean a regression if someone is used to pinning, for example pinning
>> to 12.2.2 wouldn't be possible using the same url.
>>
>> Pros: Faster release times, less need to move packages around, and
>> easier to remove a bad version
>>
>>
>> *Single version removal*
>> Our tooling would need to go and remove the known bad version from the
>> repository, which would require to rebuild the repository again, so
>> that the metadata is updated with the difference in the binaries.
>>
>> Caveats: time intensive process, almost like cutting a new release
>> which takes about a day (and sometimes longer). Error prone since the
>> process wouldn't be the same (one off, just when a version needs to be
>> removed)
>>
>> Pros: all urls for download.ceph.com and its structure are kept the same.
> _______________________________________________
> ceph-users mailing list -- ceph-users@ceph.io
> To unsubscribe send an email to ceph-users-leave@ceph.io
> 


-- 
Yoann Moulin
EPFL IC-IT
